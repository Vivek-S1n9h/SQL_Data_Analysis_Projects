# list of products with a base price greater than 500 that are featured in promo type "BOGOF":Buy one get one free

SELECT
    b.product_name AS products
FROM
    retail_events_db.fact_events AS a
LEFT JOIN
    retail_events_db.dim_products AS b 
ON 
    a.product_code = b.product_code
WHERE
    a.promo_type = "BOGOF" AND a.base_price > 500
GROUP BY
    products;