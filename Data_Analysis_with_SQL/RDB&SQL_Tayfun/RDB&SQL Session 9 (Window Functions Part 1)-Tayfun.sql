
--RDB&SQL Session 9--

-- Window Functions--


-- Write a query that returns stock amounts of products (only stock table) (use both of group and window functions)

--with group by 
select product_id, sum(quantity) as total_stock
from product.stock
group by product_id 
order by product_id

-- with window function

select  distinct product_id, sum(quantity) over (partition by product_id) as sumWF
from product.stock
order by product_id


-- write a query that returns average list price of products by brands (use both group by and WF)


-- with group by 

select brand_id, avg(list_price) as avg_price
from  product.product 
group by brand_id



--with window function 

select  distinct brand_id, avg(list_price) over( partition by brand_id) as avg_price
from product.product


-- with window function, we can add new column to a table. for example, we can add a colomn of the average list price of products by brands to product.product table


select *, avg(list_price) over( partition by brand_id) as avg_price
from product.product


-- or another examples as follow

select *, max(list_price) over( partition by brand_id) as max_price
from product.product


-- we can create new columns in the same select block by defining different partitions

select *,
 max(list_price) over( partition by brand_id) as max_price,
 min(list_price) over( partition by model_year) as min_price
from product.product

--

select	*,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by brand_id, product_id
;


---

select	product_id, brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by brand_id, category_id, model_year

---

select	product_id, brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by category_id, brand_id, model_year
;


-- 

select	distinct brand_id, category_id, model_year,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by category_id, brand_id, model_year
;

select	distinct brand_id, category_id,
		count(*) over(partition by brand_id) CountOfProductinBrand,
		count(*) over(partition by category_id) CountOfProductinCategory
from	product.product
order by category_id, brand_id
;




--- Window Frames


-- This is good example to ubderstand window frames. 

SELECT	category_id, product_id,
		COUNT(*) OVER() NOTHING,
		COUNT(*) OVER(PARTITION BY category_id) countofprod_by_cat,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id) countofprod_by_cat_2,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) prev_with_current,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) current_with_following,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) whole_rows,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) specified_columns_1,
		COUNT(*) OVER(PARTITION BY category_id ORDER BY product_id ROWS BETWEEN 2 PRECEDING AND 3 FOLLOWING) specified_columns_2
FROM	product.product
ORDER BY category_id, product_id

;

-- Cheapest product price in each category

--with group by

select category_id, min(list_price) cheapest_by_cat
from product.product
group by category_id

--with WF 

select	distinct category_id, min(list_price) over(partition by category_id) cheapest_by_cat
from	product.product
;


-- How many different product in the product table?

select distinct count(*) over() as num_of_product
from product.product
;

-- How many different product in the order_item table?


select	count(distinct product_id) UniqueProduct
from	sale.order_item
;

-- window functions does not allow  count(distinct ...)

select	count(distinct product_id) over() UniqueProduct
from	sale.order_item
;


-- Write a query that returns how many different products are in each order?

-- also calculate how many pieces of products are found in total

select	order_id, count(distinct product_id) UniqueProduct,
		sum(quantity) TotalProduct
from	sale.order_item
group by order_id
;

select  distinct [order_id]
	,count(product_id) over(partition by [order_id]) count_of_Uniqueproduct
	,sum(quantity) over(partition by [order_id]) count_of_product
from [sale].[order_item]
;



-- How many different product are in each brand in each category?

-- Sorgu sonucunun category_id ASC, bran_id ASC kuralına uygun sıralandığını gözlemleyin.
-- Bunun nedeni distinct fonksiyonudur. SQL Server veriyi ilk olarak bu şekilde sıralar (ORDER BY 1, 2) daha sonra distinct kayıtları getirir.

select	distinct category_id, brand_id,
		count(*) over(partition by brand_id, category_id) CountOfProduct
from	product.product
;

-- add brand names above query 

select	A.*, B.brand_name
from	(
		select	distinct category_id, brand_id,
				count(*) over(partition by brand_id, category_id) CountOfProduct
		from	product.product
		) A, product.brand B
where	A.brand_id = B.brand_id
;

-- second way

select	distinct category_id, A.brand_id,
		count(*) over(partition by A.brand_id, A.category_id) CountOfProduct,
		B.brand_name
from	product.product A, product.brand B
where	A.brand_id = B.brand_id
;


