SELECT * FROM sales_data LIMIT 5;

-- ==================================================
-- 1. PROFITABILITY & SALES PERFORMANCE
-- ==================================================

-- Category Profitability Analysis
-- Which categories generate the highest total revenue? 
-- This helps in focusing marketing efforts.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_category_profitability AS

SELECT 
    "Category",
    ROUND(SUM("TotalRevenue"::NUMERIC), 2) AS total_revenue
FROM sales_data
GROUP BY "Category";
--ORDER BY total_revenue DESC;

SELECT * FROM vw_category_profitability;

-- Time-Series Trend Analysis
-- What is the total revenue generated for each month of activity?

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_time_trend_analysis AS

SELECT
    DATE_TRUNC('month', "InvoiceDate") as month_trunc,
    ROUND(SUM("TotalRevenue"::NUMERIC), 2) as monthly_revenue
FROM sales_data
GROUP BY month_trunc;
-- ORDER BY month_trunc DESC;

SELECT * FROM vw_time_trend_analysis;

-- ==================================================
-- 2. CUSTOMER BEHAVIOR & SEGMENTATION
-- ==================================================

-- Customer Behavior (Average Ticket)
-- What is the average spending per customer?
-- This helps in understanding the value of the user base.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_customer_behavior_avg_ticket AS

SELECT 
    "CustomerID",
    ROUND(AVG("TotalRevenue"::NUMERIC), 2) AS avg_customer_spend 
FROM sales_data
GROUP BY "CustomerID";
--ORDER BY avg_customer_spend DESC;

SELECT * FROM vw_customer_behavior_avg_ticket;

-- Advanced Filtering: High-Value Customers
-- Get the ID of customers who have made at least 5 purchases
-- and have an average purchase spend greater than 500 currency units.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_high_value_customers AS

SELECT
    "CustomerID",
    COUNT(*) AS total_purchases,
    ROUND(AVG("TotalRevenue"::NUMERIC), 2) AS avg_spend
FROM sales_data
GROUP BY "CustomerID"
HAVING COUNT(*) >= 5 AND AVG("TotalRevenue") > 500;
--ORDER BY avg_spend DESC;

SELECT * FROM vw_high_value_customers;

-- Top 3 most purchased products within each category
-- Identifies the best-selling items per category using window functions.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_top_products_by_category AS

WITH item_count AS (
    SELECT
        "Category",
        "Description",
        COUNT("CustomerID") as total_orders,
        ROW_NUMBER() OVER(PARTITION BY "Category" ORDER BY COUNT("CustomerID") DESC) AS item_rank
    FROM sales_data
    GROUP BY "Category", "Description"
)
SELECT
    item_rank,
    "Category",
    "Description",
    total_orders
FROM item_count
WHERE item_rank <= 3;

SELECT * FROM vw_top_products_by_category;

-- ==================================================
-- 3. LOGISTICS & OPERATIONAL EFFICIENCY
-- ==================================================

-- Supply Chain Optimization
-- Which shipment providers have the highest average shipping costs?

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_highest_avg_shipping_cost AS

SELECT 
    "ShipmentProvider",
    ROUND(AVG("ShippingCost"::NUMERIC), 2) as avg_shipping_cost
FROM sales_data
GROUP BY "ShipmentProvider";
--ORDER BY avg_shipping_cost DESC;

SELECT * FROM vw_highest_avg_shipping_cost;

-- Order Priority Analysis
-- Is there a difference in average shipping costs based on OrderPriority?
-- This may reveal if "High" priority orders are more costly to process.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_avg_shipping_cost_by_order_priority AS

SELECT 
    "OrderPriority",
    ROUND(AVG("ShippingCost"::NUMERIC), 2) AS avg_shipping_cost
FROM sales_data
GROUP BY "OrderPriority";
--ORDER BY avg_shipping_cost DESC;

SELECT * FROM vw_avg_shipping_cost_by_order_priority;

-- Churn/Returns Analysis
-- Which product category has the highest return rate?
-- (i.e., what percentage of sales are marked as "Returned"?).

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_category_return_rate AS

SELECT
    "Category",
    ROUND(SUM(CASE
        WHEN "ReturnStatus" = 'Returned' THEN 1
        ELSE 0
    END)::NUMERIC / COUNT(*) * 100, 2) AS returned_status
FROM sales_data
GROUP BY "Category";
--ORDER BY returned_status DESC;

SELECT * FROM vw_category_return_rate;

-- Shipping Cost vs. Return Status
-- What is the average shipping cost for orders that were "Returned"
-- compared to those that were "Not Returned"?

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_avg_shipping_cost_for_returned AS

SELECT
    "ReturnStatus",
    ROUND(AVG("ShippingCost"::NUMERIC), 2) AS avg_shipping_cost
FROM sales_data
GROUP BY "ReturnStatus";
--ORDER BY avg_shipping_cost;

SELECT * FROM vw_avg_shipping_cost_for_returned;

-- Most used Shipment Provider
-- Identify the most frequently used shipment providers and the total volume of completed shipments.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_most_used_shipment_provider AS

SELECT
    "ShipmentProvider",
    COUNT(*) AS shipment_completed
FROM sales_data
GROUP BY "ShipmentProvider";
--ORDER BY shipment_completed DESC;

SELECT * FROM vw_most_used_shipment_provider;

-- ==================================================
-- 4. GEOGRAPHIC & PAYMENT INSIGHTS
-- ==================================================

-- Payment Method Performance
-- Analyze the average spending and total revenue generated by each payment method 
-- to understand customer transaction preferences.

-- CREATE VIEw
CREATE OR REPLACE VIEW vw_payment_method_performance AS

SELECT 
    "PaymentMethod",
    ROUND(AVG("TotalRevenue"::NUMERIC), 2) AS avg_total_revenue,
    ROUND(SUM("TotalRevenue"::NUMERIC), 2) AS total_revenue
FROM sales_data
GROUP BY "PaymentMethod";
--ORDER BY avg_total_revenue DESC;

SELECT * FROM vw_payment_method_performance;

-- Top 5 Countries by Order Volume
-- Identify the top 5 countries based on order count and their respective total revenue generation.

-- CREATE VIEW
CREATE OR REPLACE VIEW vw_top_5_countries_by_order_volume AS

SELECT
    "Country",
    COUNT(*) AS orders_completed,
    ROUND(SUM("TotalRevenue"::NUMERIC), 2) as total_revenue
FROM sales_data
GROUP BY "Country"
ORDER BY orders_completed DESC
LIMIT 5;

SELECT * FROM vw_top_5_countries_by_order_volume;