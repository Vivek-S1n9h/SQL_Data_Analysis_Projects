# display each campaign along with total revenue generated before and after the campaign
# Key fields: campaign_name , total_revenue(before_promotion), total_revenue(after_promotion)
# display values in millions

SELECT
    b.campaign_name,
    SUM(a.base_price * a.`quantity_sold(before_promo)`) / 1000000 AS `total_revenue(before_promotion)`,
    SUM(a.base_price * a.`quantity_sold(after_promo)`) / 1000000 AS `total_revenue(after_promotion)`
FROM
    retail_events_db.fact_events AS a
LEFT JOIN
    retail_events_db.dim_campaigns AS b 
ON 
    a.campaign_id = b.campaign_id
GROUP BY
    campaign_name;