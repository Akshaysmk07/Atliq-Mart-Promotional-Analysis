SELECT
    city,
    COUNT(store_id) AS no_of_stores
FROM
    dim_stores
GROUP BY
    city
ORDER BY
    no_of_stores DESC; 
    
    
