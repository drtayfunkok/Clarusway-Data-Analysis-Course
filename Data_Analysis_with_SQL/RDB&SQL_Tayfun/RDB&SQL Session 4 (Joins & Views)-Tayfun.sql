
--RDB&SQL Session 4--

-- Joins & Views--

------ INNER JOIN ------

-- List products with category names
-- Select product ID, product name, category ID and category names

SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	product.product A
INNER JOIN	product.category B
	ON	A.category_id = B.category_id
;

-- or
SELECT	A.product_id, A.product_name, A.category_id, B.category_name
FROM	product.product A,
		product. category B
WHERE	A.category_id = B.category_id
;


-- List store employees with their store information
-- Select employee name, surname, store names

SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;

------ LEFT JOIN ------

--List products that have never been ordered


SELECT	A.product_id, A.product_name, B.order_id
FROM	product.product A
LEFT JOIN	sale.order_item B ON A.product_id = B.product_id
WHERE	order_id IS NULL
;



-- List product information with stock quantities that product id is greater than 310.

SELECT	A.product_id, A.product_name, B.*
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;


------ RIGHT JOIN ------

-- Make the query you made with LEFT JOIN about stock quantities with RIGHT JOIN.

SELECT	B.product_id, B.product_name, A.*
FROM	product.stock A
RIGHT JOIN product.product B ON	A.product_id = B.product_id
WHERE	B.product_id > 310
;


------ FULL OUTER JOIN ------

-- List the stock quantities and order information of the products together

SELECT TOP 20 A.Product_id, A.store_id, A.quantity, B.product_id, B.order_id, B.list_price
FROM	product.stock A
FULL OUTER JOIN	sale.order_item B ON A.product_id = B.product_id
ORDER BY A.product_id, B.order_id
;


SELECT TOP 100 A.Product_id, B.store_id, B.quantity, C.order_id, C.list_price
FROM	
product.product A
FULL OUTER JOIN 
product.stock B  ON A.product_id = B.product_id
FULL OUTER JOIN	sale.order_item C ON A.product_id = C.product_id
ORDER BY B.store_id 
;


------ CROSS JOIN ------

--Products that are not in the stock table but available in the product table must be registered in the stock table for all stores. 
--Since it has no stock, its quantity must be 0
--and a product id must be added to the stock of all stores, so we need to cross join.



SELECT	B.store_id, A.product_id, 0 quantity
FROM	product.product A
CROSS JOIN sale.store B
WHERE	A.product_id NOT IN (SELECT product_id FROM product.stock)
ORDER BY A.product_id, B.store_id



------ SELF JOIN ------

-- List staff and their managers
-- select employee name and manager name information

SELECT	A.first_name staff_name, B.first_name manager_name
FROM	sale.staff A
JOIN	sale.staff B ON	A.manager_id = B.staff_id
ORDER BY B.first_name
;

-- or
SELECT	A.first_name, B.first_name manager_name
FROM	sale.staff A, sale.staff B
WHERE	A.manager_id = B.staff_id
ORDER BY B.first_name
;


--View--

-- we can store complex queries in views.
-- view does not produce a new table. It only stores the queries 

CREATE VIEW ProductStock AS 
SELECT	A.product_id, A.product_name, B.store_id, B.quantity
FROM	product.product A
LEFT JOIN product.stock B ON A.product_id = B.product_id
WHERE	A.product_id > 310
;

 SELECT *
 FROM ProductStock
 where store_id=1
 order by 1


Create view SaleStaff as 
SELECT	A.first_name, A.last_name, B.store_name
FROM	sale.staff A
INNER JOIN sale.store B
	ON	A.store_id = B.store_id
;


select *
from SaleStaff
