-- ==========================================
-- 1. Creating overdue view with metrics
-- ==========================================

CREATE
  OR replace VIEW olist_overdue_orders_summary AS
WITH TARGET_DATA AS (
  SELECT
    *,
    date(order_delivered_customer_date) - date(order_estimated_delivery_date) AS overdue_time
  FROM olist_orders
  WHERE date_part('month', order_estimated_delivery_date) = 8
    AND date_part('year', order_estimated_delivery_date) = 2018
    AND DATE(order_estimated_delivery_date) < DATE(order_delivered_customer_date)
)
SELECT
  to_char(order_estimated_delivery_date, 'Mon YYYY') AS report_period,
  CASE WHEN overdue_time BETWEEN 1
  AND 7 THEN '1 - 7 days' WHEN overdue_time BETWEEN 8
  AND 14 THEN '8 - 14 days' WHEN overdue_time BETWEEN 15
  AND 30 THEN '15 - 30 days' ELSE 'Over 30 days' END AS overdue_category,
  count(orders.order_id) AS order_count,
  sum(payment_value) AS total_value,
  round(avg(overdue_time), 2) AS avg_days
FROM TARGET_DATA AS orders
INNER JOIN olist_order_payments AS payments
ON orders.order_id = payments.order_id
GROUP BY report_period,
  overdue_category;

-- ==========================================
-- 2. Creating month revenue view
-- ==========================================

CREATE
  OR replace VIEW olist_month_revenue_aov AS
WITH completed_orders AS (
  SELECT
    *
  FROM olist_orders --TODO add flexible variable with docker month and year for prev month
  WHERE date_part('month', order_estimated_delivery_date) = 8
    AND date_part('year', order_estimated_delivery_date) = 2018
    AND order_status IN ('delivered', 'shipped')
),
  items_info AS (
  SELECT
    order_id,
    price,
    freight_value,
    price + freight_value AS cross_revenue
  FROM olist_order_items
)
SELECT
  to_char(order_estimated_delivery_date, 'Mon YYYY') AS report_period,
  count(*) AS orders,
  round(sum(price) :: numeric, 2) AS items_revenue,
  sum(freight_value) AS freight_value,
  round(sum(cross_revenue) :: numeric, 2) AS cross_revenue,
  round((sum(cross_revenue) / count(*)) :: numeric, 2) AS aov
FROM completed_orders AS comp
INNER JOIN items_info AS item ON item.order_id = comp.order_id
GROUP BY report_period;

-- ==========================================
-- 3. Creating payment method & installments breakdow view
-- ==========================================

CREATE
  OR replace VIEW olist_payment_method AS

WITH completed_orders AS (
  SELECT
    *
  FROM olist_orders --TODO add flexible variable with docker month and year for prev month
  WHERE date_part('month', order_estimated_delivery_date) = 8
    AND date_part('year', order_estimated_delivery_date) = 2018
    AND order_status IN ('delivered', 'shipped')
)
SELECT
  to_char(order_estimated_delivery_date, 'Mon YYYY') AS report_period,
  payment_type,
  count(*) AS total_transaction,
  round(avg(payment_installments), 2) AS volume_avg,
  ROUND((SUM(payment_value) / SUM(SUM(payment_value)) OVER () * 100) :: numeric, 1) AS share_of_volume_pct,
  round(sum(payment_value) :: numeric, 2) AS total_volume
FROM olist_order_payments AS pay
INNER JOIN completed_orders AS comp
ON comp.order_id = pay.order_id
GROUP BY report_period, payment_type;

-- ==========================================
-- 4. TODO Creating freight ratio by state view
-- ==========================================


