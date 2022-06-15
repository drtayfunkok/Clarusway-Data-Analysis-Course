
-- RDB&SQL Session 7--

--Subqueries--



-- in select statement



select	order_id,
		list_price,
		(
		select	avg(list_price)
		from	product.product
		) AS avg_price
from	sale.order_item
;



--- in where clause

select	order_id, order_date
from	sale.orders
where	order_date in (
select top 5 order_date
from	sale.orders
order by order_date desc
)
;

-- in from clause

select	order_id, order_date
from	(
		select	top 5 *
		from	sale.orders
		order by order_date desc
		) A


-- Single Row Subqueries --

-- Calculate the total price of each order. (Based on the list price of the products)

select	order_id, sum(list_price) sum_list_price
from	sale.order_item
group by order_id
;

-- solution with a subquery

select	so.order_id,
		(
		select	sum(list_price)
		from	sale.order_item
		where	order_id=so.order_id
		) AS sum_price
from	sale.order_item so
group by so.order_id
;




-- What is the difference between these two codes?

-- There is only difference between the two in terms of the use of aliases.
-- In the first query, the table in the outer query has alias, in the second query, there is only alias in the table in the subquery.
-- Our general approach should be to use alias using as many different names as possible.
-- If we don't use alias, SQL server will first start looking for the column in question in parentheses.
-- If it can, it doesn't check if the same column exists outside the parentheses.
-- If there is no column in parenthesis, outer query will also search for this column.
-- But in this case it will be necessary to use alias.
-- Because of this situation, the results of the following queries are different.
-- You can check the error status by just running the query in parentheses, and in which cases have you tested whether the subquery and the outer query are dependent?



--1. code
SELECT  B.order_id, (SELECT SUM(list_price*quantity*(1-discount)) FROM sale.order_item WHERE order_id = B.order_id ) AS TOTAL
FROM sale.order_item B
GROUP BY B.order_id
--2. code
SELECT  order_id, (SELECT SUM(B.list_price*B.quantity*(1-B.discount)) FROM sale.order_item B WHERE B.order_id = order_id ) AS TOTAL
FROM sale.order_item
GROUP BY order_id
;

-- Whether subquery and outerquery depend on each other.
-- If there is a column from the outer query in a subquery, then the two queries are dependent on each other.
-- In these cases, aliases become even more important.




-- Multiple Rows Subqueries ---

-- List all staff members in the store where Davis Thomas worked.

select	*
from	sale.staff
where	store_id = (
					select	store_id
					from	sale.staff
					where	first_name = 'Davis' and last_name = 'Thomas'
					)
;


-- List the staff whoes manager is Charles Cussona.

select	*
from	sale.staff
where	manager_id = (
					select	staff_id
					from	sale.staff
					where	first_name = 'Charles' and last_name = 'Cussona'
					)
;



-- List products that are more expensive than 'Pro-Series 49-Class Full HD Outdoor LED TV (Silver)'.





select product_id, product_name
from product.product
where list_price>(select list_price
from product.product
where product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')

--second method

select A.product_id, a.product_name, a.model_year, a.list_price, b.brand_name, c.category_name
from product.product A, product.brand B, product.category C
where list_price > 
	(select list_price
	from product.product 
	where product_name='Pro-Series 49-Class Full HD Outdoor LED TV (Silver)')
	and A.brand_id = B.brand_id
	and A.category_id = C.category_id
;



-- List all customers who shopped on the date(s) that customer Laurel Goldammer made the purchase.


SELECT *
FROM sale.customer AS SC, sale.orders AS SO
WHERE order_date IN (
				SELECT SO.order_date
				FROM sale.customer AS SC, sale.orders AS SO
				WHERE first_name = 'Laurel' AND last_name='Goldammer'
				AND SC.customer_id=SO.customer_id)
				AND SC.customer_id=SO.customer_id;


--List products made in 2021 and their categories other than Game, GPS, or Home Theater.

select product_name, list_price
from product.product
where model_year=2021 and category_id in (select category_id
from product.category
where category_name not in ('Game', 'gps', 'Home Theater'))


--second method

select	*
from	product.product
where	model_year = 2021 and
		category_id NOT IN (
						select	category_id
						from	product.category
						where	category_name in ('Game', 'GPS', 'Home Theater')
						) 
;


-- List 2020 model products. However, these products must be more expensive than all products in the Receivers Amplifiers category.
-- Sort the product name, model_year and price information from high to low price.


select *
from product.product
where model_year=2020 and list_price> ALL (select list_price
from product.product
where category_id=(select category_id
from product.category
where category_name='Receivers Amplifiers'))


--second method

SELECT *
FROM product.product
WHERE list_price > (												
SELECT max(list_price)
FROM product.product P, product.category C
WHERE C.category_name = 'Receivers Amplifiers' and P.category_id = C.category_id)
AND model_year = 2020


--List 2020 model products. But these products should be more expensive than any product in the Receivers Amplifiers category.
-- Sort the product name, model_year and price information from high to low price.


select	*
from	product.product
where	model_year = 2020 and
		list_price > (
			select	min(B.list_price)
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
		)
;
-- second method
select	*
from	product.product
where	model_year = 2020 and
		list_price > ANY (
			select	B.list_price
			from	product.category A, product.product B
			where	A.category_name = 'Receivers Amplifiers' and
					A.category_id = B.category_id
			)
;

