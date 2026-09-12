
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

COMMIT;