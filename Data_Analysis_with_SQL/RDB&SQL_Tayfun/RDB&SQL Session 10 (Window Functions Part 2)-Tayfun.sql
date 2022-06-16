

--RDB&SQL Session 10--

--Window Functions Part 2--

--Analytic Navigation Functions

-- we have to use order by for analytic navigation functions 

-- first_value function-- 


-- write a query that return most stocked product in each store

select distinct store_id,
FIRST_VALUE(product_id) over (partition by store_id order by quantity desc) most_stocked_prod
from product.stock

-- write a query that returns customers and their most valuable order with total amount of it

SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
ORDER BY 1,3 DESC;


WITH T1 AS
(
SELECT	customer_id, B.order_id, SUM(quantity * list_price* (1-discount)) net_price
FROM	sale.order_item A, sale.orders B
WHERE	A.order_id = B.order_id
GROUP BY customer_id, B.order_id
)

SELECT	DISTINCT customer_id,
		FIRST_VALUE(order_id) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MV_ORDER,
		FIRST_VALUE(net_price) OVER (PARTITION BY customer_id ORDER BY net_price DESC) MVORDER_NET_PRICE
FROM	T1


--- second method


select distinct customer_id,first_value(order_id) over(partition by customer_id order by sum_ desc) order_id
				,first_value(sum_) over(partition by customer_id order by sum_ desc) net_price
from 
(
select distinct so.[customer_id],so.order_id
		,sum([quantity]*[list_price]*(1-[discount])) over(partition by [customer_id],so.order_id order by so.order_id ) sum_
from [sale].[order_item]soi ,[sale].[orders] so
where so.[order_id]=soi.[order_id]
) A




-- write a query that returns first order date by month 

SELECT	DISTINCT YEAR(order_date) ord_year,
		MONTH(order_date) ord_month,
		FIRST_VALUE(order_date) OVER (PARTITION BY YEAR(order_date), MONTH(order_date) ORDER BY order_date) first_ord_date
FROM	sale.orders


-- second method 

with T2 as (
select year(order_date) year_ , month(order_date) month_, order_date
from sale.orders)
select distinct year_, month_, 
first_value(order_date) over (partition by year_, month_ order by order_date) first_order_date
from T2 






--last_value function

--write a query that returns most stocked product in each store 

SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock
-------
SELECT	DISTINCT store_id,
		LAST_VALUE(product_id) OVER (PARTITION BY store_id ORDER BY quantity ASC, product_id DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) most_stocked_prod
FROM	product.stock




--- LEAD & LAG functions--

-- LEAD function returns the value in next rows for each row of sorted columns values.
-- LAG function  returns the value in previous rows for each row of sorted columns values.


-- write a query that returns the order date of the one previous sale of each staff


select order_id, o.staff_id, first_name, f.last_name, order_date,
lag(order_date) over(partition by o.staff_id order by order_date) previous_order_date
from sale.staff f, sale.orders o
where f.staff_id = o.staff_id


-- second method 

SELECT	A.staff_id, B.first_name, B.last_name, A.order_id, A.order_date,
		LAG(order_date) OVER (PARTITION BY A.staff_id ORDER BY A.order_id) prev_order
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id

----


--Write a query that returns the order date of the one next sale of each staff (use the LEAD function)

SELECT	DISTINCT A.order_id, B.staff_id, B.first_name, B.last_name, order_date,
		LEAD(order_date, 1) OVER(PARTITION BY B.staff_id ORDER BY order_id) next_order_date
FROM	sale.orders A, sale.staff B
WHERE	A.staff_id = B.staff_id
;













