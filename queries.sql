USE spain_grocery;

-- ---------------------------------------------------------------------
-- Q1. Category summary: JOIN + GROUP BY + HAVING + aggregate functions
--     Only categories with at least 10 products are listed.
-- ---------------------------------------------------------------------
SELECT
    c.category_name,
    COUNT(gi.item_id)                    AS total_products,
    ROUND(AVG(gi.price_eur), 2)          AS avg_price_eur,
    MIN(gi.price_eur)                    AS cheapest_eur,
    MAX(gi.price_eur)                    AS priciest_eur,
    SUM(gi.stock_quantity)               AS units_in_stock,
    ROUND(SUM(gi.price_eur * gi.stock_quantity), 2) AS inventory_value_eur
FROM categories AS c
INNER JOIN grocery_items AS gi ON gi.category_id = c.category_id
GROUP BY c.category_id, c.category_name
HAVING COUNT(gi.item_id) >= 10
ORDER BY inventory_value_eur DESC;

-- ---------------------------------------------------------------------
-- Q2. Products priced above their own category average
--     (derived table / subquery in the JOIN)
-- ---------------------------------------------------------------------
SELECT
    gi.item_name,
    gi.brand,
    c.category_name,
    gi.price_eur,
    ROUND(ca.avg_price, 2)                AS category_avg_eur,
    ROUND(gi.price_eur - ca.avg_price, 2) AS above_avg_by
FROM grocery_items AS gi
INNER JOIN categories AS c ON c.category_id = gi.category_id
INNER JOIN (
    SELECT category_id, AVG(price_eur) AS avg_price
    FROM grocery_items
    GROUP BY category_id
) AS ca ON ca.category_id = gi.category_id
WHERE gi.price_eur > ca.avg_price
ORDER BY above_avg_by DESC;

-- ---------------------------------------------------------------------
-- Q3. Top 3 most expensive products in each category
--     (window function: ROW_NUMBER() OVER PARTITION BY, wrapped in a CTE)
-- ---------------------------------------------------------------------
WITH ranked AS (
    SELECT
        c.category_name,
        gi.item_name,
        gi.brand,
        gi.price_eur,
        ROW_NUMBER() OVER (
            PARTITION BY gi.category_id
            ORDER BY gi.price_eur DESC
        ) AS price_rank
    FROM grocery_items AS gi
    INNER JOIN categories AS c ON c.category_id = gi.category_id
)
SELECT category_name, price_rank, item_name, brand, price_eur
FROM ranked
WHERE price_rank <= 3
ORDER BY category_name, price_rank;

-- ---------------------------------------------------------------------
-- Q4. Brand report with price bands (CASE) for brands with 3+ products
-- ---------------------------------------------------------------------
SELECT
    brand,
    COUNT(*)                         AS products,
    ROUND(AVG(price_eur), 2)         AS avg_price_eur,
    CASE
        WHEN AVG(price_eur) < 2.00  THEN 'Económico (budget)'
        WHEN AVG(price_eur) < 5.00  THEN 'Medio (mid-range)'
        ELSE                             'Premium'
    END                              AS price_band
FROM grocery_items
GROUP BY brand
HAVING COUNT(*) >= 3
ORDER BY avg_price_eur DESC;

-- ---------------------------------------------------------------------
-- Q5. Items that expire within 90 days of 2026-10-19 and are low in stock
--     (date arithmetic + correlated subquery against the category average)
-- ---------------------------------------------------------------------
SELECT
    gi.item_name,
    gi.brand,
    gi.expiry_date,
    DATEDIFF(gi.expiry_date, '2026-10-19') AS days_left,
    gi.stock_quantity
FROM grocery_items AS gi
WHERE gi.expiry_date BETWEEN '2026-10-19' AND DATE_ADD('2026-10-19', INTERVAL 90 DAY)
  AND gi.stock_quantity < (
        SELECT AVG(g2.stock_quantity)
        FROM grocery_items AS g2
        WHERE g2.category_id = gi.category_id
  )
ORDER BY days_left ASC;
