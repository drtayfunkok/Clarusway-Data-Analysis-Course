
-- RDB&SQL Session 5 --

--Advanced Group Operators--


--Group by operator 
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-group-by-transact-sql





-- find the number of products for each brand 

select brand_id, 	count(*) AS CountOfProduct
from	product.product
group by brand_id
;

-- Aggregate functions doesn't  consider Null values. Thus, it is better way to use count(*) to count the number of rows 

-- If you write Count(column_name), this does not count Null values. 


-- Find the number of products for each category 

select	category_id, count(*) CountOfProduct
from	product.product
group by category_id
;

-- Find the number of products for each category with Category_id, Category_name and the number of products 
select	a.category_id, b.category_name, count(*) CountOfProduct
from	product.product a
inner join product.category b
on	a.category_id = b.category_id
group by a.category_id, b.category_name
;

--Having operator--
-- https://docs.microsoft.com/en-us/sql/t-sql/queries/select-having-transact-sql


-- list brand names which is 2016 model and the average price of list prices is greater than 1000

-- you have to use having opertor with group by operator 

select	b.brand_name, avg(a.list_price) AS AvgPrice
from	product.product a, product.brand b
where	a.brand_id = b.brand_id
		and a.model_year > 2016
group by b.brand_name
having avg(a.list_price) > 1000
order by 2 DESC
;


--list category id which max list price is more than 4000 and min list price is less than 500

select	category_id, max(list_price), min(list_price)
from	product.product
group by category_id
having max(list_price) > 4000 or
		min(list_price) < 500
;

-- find net price for each order (consider discount and quality)

select [order_id], sum([list_price]*[quantity]*(1-[discount]))
from [sale].[order_item]
group by [order_id]


---

select [order_id], sum([list_price]*[quantity]*(1-[discount]))
from [sale].[order_item]
group by [order_id]
having sum([list_price]*[quantity]*(1-[discount]))>1000
;


-- grouping sets--


-- find the number of products for each category and each model year 

select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by
	grouping sets (
				(category_id), -- 1. group
				(model_year), -- 2. group
				(category_id, model_year) -- 3. group
	)
-- having model_year is null
order by 1, 2
;


-- rollup
select	category_id, model_year, count(*) CountOfProducts
from	product.product
group by 
	rollup (category_id, model_year)
;

select	category_id, brand_id, model_year, count(*) CountOfProducts
from	product.product
group by
	rollup(category_id, brand_id, model_year)
;



-- cube
 
select	brand_id, category_id, model_year, count(*) CountOfProducts
from	product.product
group by 
	cube (brand_id, category_id, model_year)
;

-- PIVOT table--

-- https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot
-- list the number of products with respect to model years

SELECT *
FROM
			(
			SELECT Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

-- find the number of products by model years under each category 

SELECT *
FROM
			(
			SELECT category_id, Model_Year, product_id
			FROM product.product
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;

---

SELECT *
FROM
			(
			SELECT category_name, Model_Year, product_id
			FROM product.product a , product.category b
			where a.category_id=b.category_id
			) A
PIVOT
(
	count(product_id)
	FOR Model_Year IN
	(
	[2018], [2019], [2020], [2021]
	)
) AS PIVOT_TABLE
;