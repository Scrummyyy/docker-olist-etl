

ROLLBACK;

BEGIN;

-- ==========================================
-- 1. Insert data into products dataset
-- ==========================================

--TRUNCATE TABLE olist_products;

COPY olist_products
FROM 'C:\Users\Public\temp_files_olist\data\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER);

-- ==========================================
-- 2. Insert data with payment information
-- ==========================================

--TRUNCATE TABLE olist_order_payments;

COPY olist_order_payments
FROM 'C:\Users\Public\temp_files_olist\data\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER);


-- ==========================================
-- 3. Insert data with payment information
-- ==========================================

--TRUNCATE TABLE olist_order_reviews;

COPY olist_order_reviews
(review_id,order_id,review_score,review_comment_title,review_comment_message,
review_creation_date,review_answer_timestamp)
FROM 'C:\Users\Public\temp_files_olist\data\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER true);

-- ==========================================
-- 4. Insert data with geolocation cords
-- ==========================================

--TRUNCATE TABLE olist_geolocation;

COPY olist_geolocation
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) FROM
'C:\Users\Public\temp_files_olist\data\olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true);

-- ==========================================
-- 5. Insert data with sellers information
-- ==========================================

--TRUNCATE TABLE olist_sellers;

COPY olist_sellers
FROM 'C:\Users\Public\temp_files_olist\data\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER);

-- ==========================================
-- 6. Insert data with customers information
-- ==========================================

--TRUNCATE TABLE olist_order_customer;

COPY olist_order_customer
FROM 'C:\Users\Public\temp_files_olist\data\olist_customers_dataset.csv'
WITH (FORMAT csv, HEADER);

-- ==========================================
-- 7. Insert data with customers information
-- ==========================================

--TRUNCATE TABLE olist_order_items;

COPY olist_order_items
FROM 'C:\Users\Public\temp_files_olist\data\olist_order_items_dataset.csv'
WITH (FORMAT csv, HEADER);

COMMIT;