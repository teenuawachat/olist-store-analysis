-- Task 1

USE OLIST_PROJECT;

SELECT 
    CASE 
        WHEN DAYOFWEEK(order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type, 
    COUNT(*) AS total_orders, 
    round(SUM(olist_order_payments_dataset.payment_value),2) AS total_payment, 
    AVG(olist_order_payments_dataset.payment_value) AS average_payment, 
    MAX(olist_order_payments_dataset.payment_value) AS max_payment, 
    MIN(olist_order_payments_dataset.payment_value) AS min_payment 
FROM 
    olist_orders_dataset 
JOIN 
    olist_order_payments_dataset 
ON 
    olist_order_payments_dataset.order_id = olist_orders_dataset.order_id 
GROUP BY 
    day_type 
ORDER BY 
    day_type ;

-- TASK 2
-- Number of Orders with review score 5 and payment type as credit card

select count(distinct opd.order_id) as Total_orders
from
olist_order_payments_dataset as opd
inner join olist_order_reviews_dataset as ord on opd.order_id=ord.order_id
where ord.review_score=5 and opd.payment_type="credit_card";                                     

 -- TASK 3
/*Average number of days taken for order_delivered_customer_date for pet_shop */

USE olist_project;
Select
    Prod.product_category_name,
    ROUND(Avg(datediff(ord.order_delivered_customer_date, ord.order_purchase_timestamp))) as Avg_delivery_days
From olist_orders_dataset ord
Join
    (select product_id, order_id, product_category_name
    From olist_products_dataset
    Join olist_order_items_dataset using(product_id)) as prod
On ord.order_id = prod.order_id
Where prod.product_category_name = 'pet_shop'
Group by prod.product_category_name;

-- TASK 4

USE olist_project;

WITH orderitemsAvg AS (
    SELECT 
        ROUND(AVG(item.price)) AS avg_order_item_price
    FROM olist_order_items_dataset item
    JOIN olist_orders_dataset ord ON item.order_id = ord.order_id
    JOIN olist_customers_dataset cust ON ord.customer_id = cust.customer_id
    WHERE cust.customer_city = "Sao Paulo"
)
SELECT 
    (SELECT avg_order_item_price FROM orderitemsAvg) AS avg_order_item_price,
    ROUND(AVG(pmt.payment_value)) AS avg_payment_value
FROM olist_order_payments_dataset pmt
JOIN olist_orders_dataset ord ON pmt.order_id = ord.order_id
JOIN olist_customers_dataset cust ON ord.customer_id = cust.customer_id
WHERE cust.customer_city = "Sao Paulo";



-- TASK 5
/* Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores*/

SELECT
rew.review_score as Review,
round(AVG(datediff(ord.order_delivered_customer_date, order_purchase_timestamp)),0) as "Average Shipping Days"
FROM olist_orders_dataset as ord
JOIN olist_order_reviews_dataset as rew on rew.order_id = ord.order_id
GROUP BY rew.review_score
ORDER BY rew.review_score;

 


