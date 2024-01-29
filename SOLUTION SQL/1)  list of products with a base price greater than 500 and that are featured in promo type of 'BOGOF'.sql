SELECT DISTINCT
    p.product_code,
    p.product_name,
    p.category,
    f.base_price,
    f.promo_type
FROM
    dim_products p
JOIN
    fact_events f ON p.product_code = f.product_code
WHERE
    f.base_price > 500
    AND f.promo_type = 'BOGOF';



