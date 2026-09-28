WITH
TARGET_DATA AS(
SELECT * ,
date(order_delivered_customer_date) - date(order_estimated_delivery_date) as overdue_time
FROM olist_orders

 --TODO add flexible variable with docker month and year for prev month
WHERE date_part('month', order_estimated_delivery_date) = 8 AND
date_part('year', order_estimated_delivery_date) = 2018
AND DATE(order_estimated_delivery_date) < DATE(order_delivered_customer_date)
)

SELECT case
when overdue_time between 1 and 7 then '1 - 7 days'
when overdue_time between 8 and 14 then '8 - 14 days'
when overdue_time between 15 and 30 then '15 - 30 days'
else 'Over 30 days'
end as overdue_category, *
-- count(order_id), *
-- group by 1
FROM TARGET_DATA;