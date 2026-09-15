



BEGIN;

-- ==========================================
-- 1. Creating products table with their parameters
-- ==========================================

CREATE TABLE IF NOT EXISTS olist_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(50),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
	product_width_cm INT
);

-- ==========================================
-- 2. Creating table with order payments information
-- ==========================================

CREATE TABLE IF NOT EXISTS olist_order_payments (
    order_id VARCHAR(50), -- it's duplicated
    payment_sequential SMALLINT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value FLOAT(24)
);

-- ==========================================
-- 3. Creating review table
-- ==========================================

CREATE TABLE IF NOT EXISTS olist_order_reviews (
    review_id VARCHAR(50), -- Uniquely identifies each review in this table
    order_id VARCHAR(50) NOT NULL,    -- Identifies which order this review belongs to
    review_score SMALLINT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATE,
    review_answer_timestamp TIMESTAMPTZ
);

-- ==========================================
-- 4. Creating geolocation info table
-- ==========================================

CREATE TABLE IF NOT EXISTS olist_geolocation (
    geolocation_zip_code_prefix CHAR(5),
    geolocation_lat FLOAT(5),
    geolocation_lng FLOAT(5),
    geolocation_city VARCHAR(70),
    geolocation_state CHAR(2),
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

-- ==========================================
-- 5. Creating sellers info table
-- ==========================================

CREATE TABLE IF NOT EXISTS olist_sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix CHAR(5) NOT NULL,
    seller_city VARCHAR(70),
    seller_state CHAR(2)
);

COMMIT;
