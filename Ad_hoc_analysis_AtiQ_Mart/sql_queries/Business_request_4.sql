# calculate (Incremental stock qty/unit) ISU % for Diwali campaign 
# provide ranking based on ISU %
# key_fields: category, isu_%, rank_order
# ISU_%  = (total_qty_sold_after_promo - total_qty_sold_before_promo)/total_qty_sold_before_promo*100

WITH cte AS (
    SELECT
        b.category,
        SUM(a.`quantity_sold(before_promo)`) AS quantity_before_promo,
        SUM(a.`quantity_sold(after_promo)`) AS quantity_after_promo
    FROM
        retail_events_db.fact_events AS a
    LEFT JOIN
        retail_events_db.dim_products AS b 
    ON 
        a.product_code = b.product_code
    LEFT JOIN
        retail_events_db.dim_campaigns AS c 
    ON 
        a.campaign_id = c.campaign_id
    WHERE
        c.campaign_name = "Diwali"
    GROUP BY
        category
)
SELECT
    category,
    ((quantity_after_promo - quantity_before_promo) / quantity_before_promo) * 100 AS `ISU %`,
    RANK() OVER (ORDER BY ((quantity_after_promo - quantity_before_promo) / quantity_before_promo) DESC) AS rank_order
FROM
    cte
GROUP BY
    category;