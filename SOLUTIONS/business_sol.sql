-- BUSINESS REQUEST -1 
-- Provide a list of products with a base price greater than 500 and that are featured in promo type of 'BOGOF' (Buy One Get One Free).
-- This information will help us identify high-value products that are currently being heavily discounted, 
-- which can be useful for evaluating our pricing and promotion strategies
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

-- BUSINESS REQUEST -2 
-- Generate a report that provides an overview of the number of stores in each city.
--  The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence. 
-- The report includes two essential fields: city and store count, which will assist in optimizing our retail operations

SELECT
    city,
    COUNT(store_id) AS no_of_stores
FROM
    dim_stores
GROUP BY
    city
ORDER BY
    no_of_stores DESC;
    
-- BUSINESS REQUEST -3
-- Generate a report that displays each campaign along with the total revenue generated before and after the campaign? 
-- The report includes three key fields: campaign_name,1 total_revenue(before_promotion), total_revenue(after_promotion). 
-- This report should help in evaluating the financial impact of our promotional campaigns. (Display2 the values in millions) 
SELECT 
    c.campaign_name,
    CONCAT(ROUND(SUM(base_price * `quantity_sold(before_promo)`) / 1000000, 2), 'M') AS `Total_Revenue(Before_Promotion)`,
    CONCAT(ROUND(SUM(
        CASE
            WHEN promo_type = 'BOGOF' THEN base_price * 0.5 * 2* `quantity_sold(after_promo)`
            WHEN promo_type = '50% OFF' THEN base_price * 0.5 * `quantity_sold(after_promo)`
            WHEN promo_type = '25% OFF' THEN base_price * 0.75 * `quantity_sold(after_promo)`
            WHEN promo_type = '33% OFF' THEN base_price * 0.67 * `quantity_sold(after_promo)`
            WHEN promo_type = '500 Cashback' THEN (base_price - 500) * `quantity_sold(after_promo)`
            ELSE base_price * `quantity_sold(after_promo)`
        END
    ) / 1000000, 2), 'M') AS `Total_Revenue(After_Promotion)`
FROM 
    retail_events_db.fact_events fe
JOIN 
    retail_events_db.dim_campaigns c ON fe.campaign_id = c.campaign_id
GROUP BY 
    c.campaign_name;

-- BUSINESS REQUEST - 4
-- Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
-- Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: 
-- category, isu%, and rank order. This information will assist in assessing the category-wise success and impact of 
-- the Diwali campaign on incremental sales.

-- Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage increase/decrease 
-- in quantity sold (after promo) compared to quantity sold (before promo)

WITH sales_with_adjusted_quantity AS (
    SELECT 
        fe.*,
        dp.category,
        dc.campaign_name,
        -- Adjust quantity for BOGOF offers
        IF(fe.promo_type = 'BOGOF', `quantity_sold(after_promo)` * 2, `quantity_sold(after_promo)`) AS adjusted_quantity_after_promo
    FROM retail_events_db.fact_events fe
    JOIN dim_campaigns dc USING (campaign_id)
    JOIN dim_products dp USING (product_code)
    WHERE dc.campaign_name = 'Diwali'
),

category_wise_isu AS (
    SELECT 
        campaign_name,
        category,
        ROUND(
            ((SUM(adjusted_quantity_after_promo) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`)) * 100,
            2
        ) AS `ISU%`
    FROM sales_with_adjusted_quantity
    GROUP BY campaign_name, category
)

SELECT 
    campaign_name,
    category,
    `ISU%`,
    RANK() OVER (ORDER BY `ISU%` DESC) AS `ISU%_Rank`
FROM category_wise_isu;

-- BUSINESS REQUEST - 5
-- Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns. 
-- The report will provide essential information including product name, category, and ir%. 
-- This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, 
-- assisting in product optimization
WITH product_revenue_comparison AS (
    SELECT 
        dp.category,
        dp.product_name,
        -- Total revenue before promotion
        SUM(fe.base_price * fe.`quantity_sold(before_promo)`) AS total_revenue_before_promo,

        -- Total revenue after promotion (adjusted based on promo type)
        SUM(CASE
            WHEN fe.promo_type = 'BOGOF' THEN fe.base_price * 0.5 * 2 * fe.`quantity_sold(after_promo)`
            WHEN fe.promo_type = '50% OFF' THEN fe.base_price * 0.5 * fe.`quantity_sold(after_promo)`
            WHEN fe.promo_type = '25% OFF' THEN fe.base_price * 0.75 * fe.`quantity_sold(after_promo)`
            WHEN fe.promo_type = '33% OFF' THEN fe.base_price * 0.67 * fe.`quantity_sold(after_promo)`
            WHEN fe.promo_type = '500 cashback' THEN (fe.base_price - 500) * fe.`quantity_sold(after_promo)`
        END) AS total_revenue_after_promo
    FROM retail_events_db.fact_events fe
    JOIN dim_products dp USING (product_code)
    JOIN dim_campaigns dc USING (campaign_id)
    GROUP BY dp.product_name, dp.category
),

product_incremental_revenue AS (
    SELECT 
        *,
        -- Incremental Revenue (IR)
        (total_revenue_after_promo - total_revenue_before_promo) AS incremental_revenue,
        -- Incremental Revenue Percentage (IR%)
        ROUND(((total_revenue_after_promo - total_revenue_before_promo) / total_revenue_before_promo) * 100, 2) AS `IR%`
    FROM product_revenue_comparison
)

-- Final output: Top 5 products based on IR%
SELECT 
    product_name,
    category,
    incremental_revenue AS `IR`,
    `IR%`,
    RANK() OVER (ORDER BY `IR%` DESC) AS rank_ir
FROM product_incremental_revenue
LIMIT 5;
