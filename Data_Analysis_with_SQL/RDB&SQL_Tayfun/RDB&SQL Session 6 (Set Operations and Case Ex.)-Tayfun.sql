--RDB & SQL Session 6--

--Set Operations and Case Expression--


--Set Operations--


-- UNION operator 

-- list customer's first names and last names living Charlotte and Aurora cities 

SELECT first_name, last_name
FROM sale.customer
where city='Charlotte'
UNION 
SELECT first_name, last_name
FROM sale.customer
where city='Aurora'

--list customers and staff's email adress by unique 

SELECT email 
FROM sale.staff
UNION 
SELECT email
FROM sale.customer

-- UNION ALL

--list first and last names whoes first name is Thomas or last name is Thomas

SELECT first_name, last_name
FROM sale.customer
where first_name='Thomas'
UNION ALL
SELECT first_name, last_name
FROM sale.customer
where last_name='Thomas'


--Another solution

SELECT first_name, last_name
FROM sale.customer
where first_name='Thomas' OR last_name='Thomas'

--INTERSECT

-- Write a query that returns brands that have products for both 2018 and 2019.

select	A.brand_id, B.brand_name
from	product.product A, product.brand B
where	a.brand_id = b.brand_id and
		a.model_year = 2018
INTERSECT
select	A.brand_id, B.brand_name
from	product.product A, product.brand B
where	a.brand_id = b.brand_id and
		a.model_year = 2019

-- Write a query that returns customers who have orders for both 2018, 2019, and 2020


select B.first_name, B.last_name
from sale.orders A, sale.customer B
where A.customer_id=B.customer_id and YEAR( A.order_date)=2018
intersect
select B.first_name, B.last_name
from sale.orders A, sale.customer B
where A.customer_id=B.customer_id and YEAR(A.order_date)=2019
intersect
select B.first_name, B.last_name
from sale.orders A, sale.customer B
where A.customer_id=B.customer_id and YEAR(A.order_date)=2020

--list customer's last names living Charlotte and Aurora cities 

SELECT last_name
FROM sale.customer
where city='Charlotte'
intersect
SELECT last_name
FROM sale.customer
where city='Aurora'

--list customers and staff's email adresses which are the same 

select	email
from	sale.staff
intersect
select	email
from	sale.customer


--EXCEPT

-- Write a query that returns brands that have a 2018 model product but not a 2019 model product.

SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2018
EXCEPT
SELECT A.brand_id, B.brand_name
FROM product.product A, product.brand B
WHERE A.brand_id = B.brand_id
    AND A.model_year = 2019;

--write a query that returns  products that were ordered in 2019 and not ordered in other years.

select	B.product_id, C.product_name
from	sale.orders A, sale.order_item B, product.product C
where	Year(A.order_date) = 2019 AND
		A.order_id = B.order_id AND
		B.product_id = C.product_id
except
select	B.product_id, C.product_name
from	sale.orders A, sale.order_item B, product.product C
where	Year(A.order_date) <> 2019 AND
		A.order_id = B.order_id AND
		B.product_id = C.product_id
;


--second solution 

Select C.product_id, D.product_name
from 
(select B.product_id
from sale.orders A, sale.order_item B
where Year(A.order_date)=2019 and 
A.order_id=B.order_id
except 
select B.product_id
from sale.orders A, sale.order_item B
where Year(A.order_date)!=2019 and 
A.order_id=B.order_id) C, product.product D
where C.product_id=D.product_id


-- List these 5 brands that do not have both 2018 and 2019 models.


select	brand_id, brand_name
from	product.brand
except
select	*
from	(
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2018
		INTERSECT
		select	A.brand_id, B.brand_name
		from	product.product A, product.brand B
		where	a.brand_id = b.brand_id and
				a.model_year = 2019
		) A




-- The amount of products that were ordered by years 


SELECT *
FROM
			(
			SELECT	b.product_id, year(a.order_date) OrderYear, B.item_id
			FROM	SALE.orders A, sale.order_item B
			where	A.order_id = B.order_id
			) A
PIVOT
(
	count(item_id)
	FOR OrderYear IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1


---

SELECT *
FROM
			(
			SELECT P.product_name, P.product_id, YEAR(O.order_date) as order_year
			FROM product.product P, sale.orders O, sale.order_item OI 
			WHERE P.product_id = OI.product_id AND O.order_id = OI.order_id
			) A
PIVOT
(
	count(product_id)
	FOR order_year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
order by 1
;


--Case Expression--


--Simple CASE Expression 

select	order_id, order_status,
case order_status
when 1 then 'Pending'
when 2 then 'Processing'
when 3 then 'Rejected'
when 4 then 'Completed'
end order_status_desc
from	sale.orders


--Add the store names of the employees to the Staff table.


select first_name, last_name, store_id,
case store_id
when 1 then 'Davi techno Reatil'
when 2 then 'The BFLO Store'
when 3 then 'Burkes Outlet'
end as Store_name 
from sale.staff

--Searched CASE Expression

select	order_id, order_status,
case 
when order_status=1 then 'Pending'
when order_status=2 then 'Processing'
when order_status=3 then 'Rejected'
when order_status=4 then 'Completed'
else 'others'
end order_status_desc
from	sale.orders


-- Specify the service providers in the e-mail addresses of the customers by creating a new column.


SELECT first_name, last_name,email,
	CASE
		WHEN email LIKE '%gmail%' THEN 'Gmail'
		WHEN email LIKE '%hotmail%' THEN 'Hotmail'
		WHEN email LIKE '%yahoo%' THEN 'Yahoo'
		ELSE 'Other'
	END AS email_service_provider
FROM sale.customer


--  Find customers who ordered products in both mp4 players, Computer Accessories and Speakers categories in the same order.


select	C.first_name, C.last_name
from	(
		select	c.order_id, count(distinct a.category_id) uniqueCategory
		from	product.category A, product.product B, sale.order_item C
		where	A.category_name in ('Computer Accessories', 'Speakers', 'mp4 player') AND
				A.category_id = B.category_id AND
				B.product_id = C.product_id
		group by C.order_id
		having	count(distinct a.category_id) = 3
		) A, sale.orders B, sale.customer C
where	A.order_id = B.order_id AND
		B.customer_id = C.customer_id
;

--other method 


SELECT	first_name, last_name
FROM
	(
	SELECT	A.customer_id, A.first_name, A.last_name, C.order_id, 
			SUM(CASE WHEN E.category_name = 'Computer Accessories' THEN 1 ELSE 0 END) AS  C1,
			SUM(CASE WHEN E.category_name = 'Speakers' THEN 1 ELSE 0 END) AS C2,
			SUM(CASE WHEN E.category_name = 'mp4 player' THEN 1 ELSE 0 END) AS C3
	FROM	SALE.customer A, SALE.orders B, SALE.order_item C, product.product D, product.category E
	WHERE	A.customer_id = B.customer_id
			AND B.order_id = C.order_id
			AND C.product_id =D.product_id
			AND D.category_id = E.category_id
	GROUP BY A.customer_id, A.first_name, A.last_name, C.order_id
	) A
WHERE C1 > 0 AND C2 > 0 AND C3 > 0
;



/* Create a new column that contains labels of the shipping speed of products.
If the product has not been shipped yet, it will be marked as "Not Shipped",
If the product was shipped on the day of order, it will be labeled as "Fast".
If the product is shipped no later than two days after the order day, it will be labeled as "Normal"
If the product was shipped three or more days after the day of order, it will be labeled as "Slow"
*/

SELECT	*,
		CASE WHEN shipped_date IS NULL THEN 'Not Shipped'
			 WHEN order_date = shipped_date THEN 'Fast' -- DATEDIFF (DAY, ORDER_DATE, SHIPPED_DATE) = 0
			 WHEN DATEDIFF (DAY, order_date, shipped_date) BETWEEN 1 AND 2 THEN 'Normal'
			 ELSE 'Slow'
		END AS ORDER_LABEL,
		DATEDIFF (DAY, ORDER_DATE, shipped_date) datedif
FROM	sale.orders
order by datedif
;

--Write a query that returns the number distributions of the orders in the previous query result, according to the days of the week


SELECT	SUM(CASE WHEN DATENAME (DW, order_date) = 'Monday' THEN 1 ELSE 0 END) AS Monday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Tuesday' THEN 1 ELSE 0 END) AS Tuesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Wednesday' THEN 1 ELSE 0 END) AS Wednesday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Thursday' THEN 1 ELSE 0 END) AS Thursday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Friday' THEN 1 ELSE 0 END) AS Friday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Saturday' THEN 1 ELSE 0 END) AS Saturday,
		SUM(CASE WHEN DATENAME (DW, order_date) = 'Sunday' THEN 1 ELSE 0 END) AS Sunday
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2
;

-- we can solve this question with pivot function.