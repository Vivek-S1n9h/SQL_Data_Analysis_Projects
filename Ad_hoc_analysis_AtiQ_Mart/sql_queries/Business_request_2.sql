# overview of number of stores in a city in descending order
# key fields: city, store_count
# To identify cities with higher store presence

SELECT
    city,
    COUNT(store_id) AS store_count
FROM
    retail_events_db.dim_stores
GROUP BY
    city
ORDER BY
    store_count DESC;
