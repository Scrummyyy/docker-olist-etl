
ROLLBACK;

BEGIN;

-- ==========================================
-- 1. Insert data into products dataset
-- ==========================================

TRUNCATE TABLE olist_products;

COPY olist_products
FROM 'C:\Users\Public\temp_files_olist\data\olist_products_dataset.csv'
WITH (FORMAT csv, HEADER);

-- ==========================================
-- 2. Insert data with payment information
-- ==========================================

TRUNCATE TABLE olist_order_payments;

COPY olist_order_payments
FROM 'C:\Users\Public\temp_files_olist\data\olist_order_payments_dataset.csv'
WITH (FORMAT csv, HEADER);

COMMIT;

-- ==========================================
-- 3. Insert data with payment information
-- ==========================================

TRUNCATE TABLE olist_order_reviews;

COPY olist_order_reviews
FROM 'C:\Users\Public\temp_files_olist\data\olist_order_reviews_dataset.csv'
WITH (FORMAT csv, HEADER);

-- ==========================================
-- 4. Insert data with geolocation cords
-- ==========================================

TRUNCATE TABLE olist_geolocation;

COPY olist_geolocation
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) FROM
'C:\Users\Public\temp_files_olist\data\olist_geolocation_dataset.csv'
WITH (FORMAT csv, HEADER true);

COMMIT;

-- ==========================================
-- 5. Insert data with sellers information
-- ==========================================

TRUNCATE TABLE olist_sellers;

COPY olist_sellers
FROM 'C:\Users\Public\temp_files_olist\data\olist_sellers_dataset.csv'
WITH (FORMAT csv, HEADER);