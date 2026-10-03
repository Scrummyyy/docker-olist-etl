create or replace view olist_overdue_orders_summary as
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

SELECT
to_char(order_estimated_delivery_date, 'Mon YYYY') as report_period,
case
when overdue_time between 1 and 7 then '1 - 7 days'
when overdue_time between 8 and 14 then '8 - 14 days'
when overdue_time between 15 and 30 then '15 - 30 days'
else 'Over 30 days'
end as overdue_category,
count(orders.order_id) as order_count, sum(payment_value) as total_value,
round(avg(overdue_time), 2) as avg_days
FROM TARGET_DATA as orders
INNER join olist_order_payments as payments on orders.order_id = payments.order_id
group by report_period, overdue_category;

#TODO finish this query
with
completed_orders as(
SELECT *
FROM olist_orders
WHERE date_part('month', order_estimated_delivery_date) = 8 AND
date_part('year', order_estimated_delivery_date) = 2018 and
order_status in ('delivered', 'shipped')
),
select to_char(order_estimated_delivery_date, 'Mon YYYY') as report_period,-- *
round(sum(price)::numeric, 2) as items_revenue, sum(freight_value) as freight_value,
--sum(items_revenue, freight_value) as cross_revenue
from completed_orders as comp
--left join olist_order_payments as pay on comp.order_id = pay.order_id
inner join olist_order_items as items on comp.order_id = items.order_id
group by 1



