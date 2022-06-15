

--RDB & SQL Session 8--
-- Correlated Subqueries & Common Table Expressions (CTE)--



-- Correlated Subqueries---

--Exists and not exists--


-- list States where 'Apple - Pre-Owned iPad 3 - 32GB - White'  product is not ordered



select	distinct C.state
from	product.product P,
		sale.order_item I,
		sale.orders O,
		sale.customer C
where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
		P.product_id = I.product_id and
		I.order_id = O.order_id and
		O.customer_id = C.customer_id
;

select	distinct C2.state
from	sale.customer C2
where	not exists (
		    select	1
			from	product.product P,
					sale.order_item I,
					sale.orders O,
					sale.customer C
			where	P.product_name = 'Apple - Pre-Owned iPad 3 - 32GB - White' and
					P.product_id = I.product_id and
					I.order_id = O.order_id and
					O.customer_id = C.customer_id and
					C2.state = C.state
		)
;

-- list stock information of the products in 'Davi techno Retail' store but 'Burkes Outlet' store hasn't got any stock of that products 

SELECT PC.product_id, PC.store_id, PC.quantity
FROM product.stock PC, sale.store SS
WHERE PC.store_id = SS.store_id AND SS.store_name = 'Davi techno Retail' AND
	NOT EXISTS ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
			FROM product.stock A, sale.store B
			WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				PC.product_id = A.product_id AND A.quantity>0
	)
;



select SS.store_name, SS.store_id,  PS.product_id, PS.quantity
from sale.store SS, product.stock PS
where SS.store_id=PS.store_id and SS.store_name='Davi techno Retail' and not exists ( SELECT DISTINCT A.product_id, A.store_id, A.quantity
			FROM product.stock A, sale.store B
			WHERE A.store_id = B.store_id AND B.store_name = 'Burkes Outlet' AND
				PS.product_id = A.product_id AND A.quantity>0
	)


--Find products bought from Brukes Outlet but never bought from BFLO Store.

SELECT P.product_name, p.list_price, p.model_year
FROM product.product P
WHERE NOT EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
				and P.product_id = I.product_id)
	AND
	EXISTS (
		SELECt	I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
				and P.product_id = I.product_id)
;



SELECT	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'Burkes Outlet'
except
		SELECt	distinct I.product_id
		FROM	sale.order_item I,
				sale.orders O,
				sale.store S
		WHERE	I.order_id = O.order_id AND S.store_id = O.store_id
				AND S.store_name = 'The BFLO Store'
;


-- Common Table Expressions (CTE)--

--with example

-- list customers who are in Austin city and have an order prior to the last order of Jerald Berray

with tbl AS (
	select	max(b.order_date) JeraldLastOrderDate
	from	sale.customer a, sale.orders b
	where	a.first_name = 'Jerald' and a.last_name = 'Berray'
			and a.customer_id = b.customer_id
)
select	*
from	sale.customer a,
		Sale.orders b,
		tbl c
where	a.city = 'Austin' and a.customer_id = b.customer_id and
		b.order_date < c.JeraldLastOrderDate
;



Create view tbl AS (
	select	max(b.order_date) JeraldLastOrderDate
	from	sale.customer a, sale.orders b
	where	a.first_name = 'Jerald' and a.last_name = 'Berray'
			and a.customer_id = b.customer_id
)
select	*
from	sale.customer a,
		Sale.orders b,
		tbl c
where	a.city = 'Austin' and a.customer_id = b.customer_id and
		b.order_date < c.JeraldLastOrderDate
;


-- Return the last sale date and the total number of products (in the product table) of Logitech and Sony brands in the same sql query.



with tbl as(
	select	br.brand_id, br.brand_name, max(so.order_date) LastOrderDate
	from	sale.orders so, sale.order_item soi, product.product pr, product.brand br
	where	so.order_id=soi.order_id and
			soi.product_id = pr.product_id and
			pr.brand_id = br.brand_id
	group by br.brand_id, br.brand_name
),
tbl2 as(
	select	pb.brand_id, pb.brand_name, count(*) count_product
	from	product.brand pb, product.product pp
	where	pb.brand_id=pp.brand_id
	group by pb.brand_id, pb.brand_name
)
select	*
from	tbl a, tbl2 b
where	a.brand_id=b.brand_id 
and a.brand_name in ('Logitech',  'Sony')
;



-- Recursive CTE example--

-- create a table with a number in each row in ascending order from 0 to 9 

with cte AS (
	select 0 rakam
	union all
	select rakam + 1
	from cte
	where rakam < 9
)
select * from cte;



-- list all days of 2020 january. 

with Jan as (
	select	cast('2020-01-01' as date) jan_date
	union all
	select	cast(DATEADD(DAY, 1, jan_date) as date) jan_date
	from Jan
	where jan_date < '2020-01-31'
)
select * from Jan;




with Jan AS (
	select cast('2020-01-01' as date) AS jan_day
	union all
	select DATEADD(DAY,1,jan_day)
	from Jan
	where jan_day < EOMONTH('2020-01-01')
)
select jan_day jan_date, day(jan_day) jan_day, month(jan_day) jan, year(jan_day) jan_year,
	EOMONTH(jan_day) TheEndOfMonth
from Jan;



-- write a query that returns all staff with their manager ids (use recursive CTE)

with cte as (
	select	staff_id, first_name, manager_id
	from	sale.staff
	where	staff_id = 1
	union all
	select	a.staff_id, a.first_name, a.manager_id
	from	sale.staff a, cte b
	where	a.manager_id = b.staff_id
)
select *
from	cte
;


-- list the stores which their earnings are under the avarage store earnings in 2018 

WITH T1 AS (
SELECT	c.store_name, SUM(list_price*quantity*(1-discount)) Store_earn
FROM	sale.orders A, SALE.order_item B, sale.store C
WHERE	A.order_id = b.order_id
AND		A.store_id = C.store_id
AND		YEAR(A.order_date) = 2018
GROUP BY C.store_name
),
T2 AS (
SELECT	AVG(Store_earn) Avg_earn
FROM	T1
)
SELECT *
FROM T1, T2
WHERE T2.Avg_earn > T1.Store_earn
;
