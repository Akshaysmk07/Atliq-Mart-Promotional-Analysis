SELECT
    p.product_name,
    p.category,
    round((
        (SUM(f.base_price * f.`quantity_sold(after_promo)`) - SUM(f.base_price * f.`quantity_sold(before_promo)`)) /
         SUM(f.base_price * f.`quantity_sold(before_promo)`)
    ) * 100 ,2) AS IR_percentage
FROM
    dim_products p
JOIN
    fact_events f ON p.product_code = f.product_code
GROUP BY
    p.product_name, p.category
ORDER BY
    IR_percentage DESC
LIMIT 5;
