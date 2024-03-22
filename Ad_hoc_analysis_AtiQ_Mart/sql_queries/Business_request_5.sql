# Top 5 products, ranked by (Incremental Revenue percentage) IR_% across all campaigns
# key fields: product_name, category, IR_%
# IR_% = (total_revenue_after_promo - total_revenue_before_promo)/total_revenue_before_promo*100 

WITH total_revenue AS (
    SELECT
        b.product_name AS product,
        b.category AS category,
        SUM(a.base_price * a.`quantity_sold(before_promo)`) / 1000000 AS revenue_bp,
        SUM(a.base_price * a.`quantity_sold(after_promo)`) / 1000000 AS revenue_ap
    FROM
        retail_events_db.fact_events AS a
    LEFT JOIN
        retail_events_db.dim_products AS b 
    ON 
        a.product_code = b.product_code
    GROUP BY
        product, category
)

SELECT
    cte.product,
    cte.category,
    ((SUM(cte.revenue_ap) - SUM(cte.revenue_bp)) / SUM(cte.revenue_bp)) * 100 AS `IR %`
FROM
    total_revenue AS cte
GROUP BY
    product, category
ORDER BY 
	`IR %` DESC
LIMIT 5;