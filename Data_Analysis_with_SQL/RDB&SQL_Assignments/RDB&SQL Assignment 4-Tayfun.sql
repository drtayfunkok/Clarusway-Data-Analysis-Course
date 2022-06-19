
--Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.


USE SampleRetail;


WITH TB AS (
 SELECT A.product_id,A.TotalQuantity,A.LeadProduct,

        CASE 

           WHEN LeadProduct > TotalQuantity THEN 1
           WHEN LeadProduct < TotalQuantity THEN -1
           WHEN LeadProduct = TotalQuantity THEN 0
        END AS EffectProduct

        FROM (
      SELECT product_id,discount,SUM(quantity) AS TotalQuantity,
          LEAD(SUM(quantity)) OVER(PARTITION BY product_id ORDER BY  discount) AS LeadProduct
      FROM sale.order_item
      GROUP BY product_id,discount) A)
	SELECT product_id,
       
       CASE

       WHEN SUM(EffectProduct) > 0  THEN 'Positive'
       WHEN SUM(EffectProduct) < 0  THEN 'Negative'
       ELSE 'Neutral'
       END AS DiscountEffect

FROM TB
GROUP BY product_id


