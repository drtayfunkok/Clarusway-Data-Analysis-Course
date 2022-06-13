-- I created a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products below or not.

--1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)

--2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)

--3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)


USE SampleRetail


CREATE VIEW Table_E AS 
SELECT 
	D.customer_id,
	D.first_name,
	D.last_name
FROM 
	sale.order_item B
JOIN product.product A ON A.product_id = B.product_id
JOIN sale.orders C ON C.order_id = B.order_id
JOIN sale.customer D ON D.customer_id = C.customer_id

WHERE A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';

CREATE VIEW Table_F AS 
SELECT 
	D.customer_id,
	D.first_name,
	D.last_name,
	A.product_name 
FROM 
	sale.order_item B

JOIN product.product A ON A.product_id = B.product_id
JOIN sale.orders C ON C.order_id = B.order_id
JOIN sale.customer D ON D.customer_id = C.customer_id

WHERE A.product_name = 'Polk Audio - 50 W Woofer - Black';

CREATE VIEW TABLE_G AS 
SELECT 
	D.customer_id,
	D.first_name,
	D.last_name,
	A.product_name 
FROM sale.order_item B

JOIN product.product A ON A.product_id = B.product_id
JOIN sale.orders C ON C.order_id = B.order_id
JOIN sale.customer D ON D.customer_id = C.customer_id

WHERE A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)';

CREATE VIEW table_H AS 
SELECT 
	D.customer_id,
	D.first_name,
	D.last_name,
	A.product_name 
FROM sale.order_item B

JOIN product.product A ON A.product_id = B.product_id
JOIN sale.orders C ON B.order_id = C.order_id
JOIN sale.customer D ON D.customer_id = C.customer_id

WHERE A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)';


SELECT 
	Table_E.customer_id,
	Table_E.first_name,
	TABLE_E.last_name,
    
ISNULL(NULLIF(ISNULL(NULLIF(Table_F.product_name,'Yes'),'No'),'Polk Audio - 50 W Woofer - Black'),'Yes') AS First_product,
ISNULL(NULLIF(ISNULL(NULLIF(Table_G.product_name,'Yes'),'No'),'SB-2000 12 500W Subwoofer (Piano Gloss Black)'),'Yes') AS Second_product,
ISNULL(NULLIF(ISNULL(NULLIF(Table_H.product_name,'Yes'),'No'),'Virtually Invisible 891 In-Wall Speakers (Pair)'),'Yes') AS Third_product

FROM Table_E 
LEFT JOIN Table_F
ON Table_F.customer_id = Table_E.customer_id
LEFT  JOIN Table_G
ON Table_G.customer_id = Table_E.customer_id
LEFT JOIN Table_H
ON Table_H.customer_id = Table_E.customer_id
ORDER BY Table_E.customer_id;
