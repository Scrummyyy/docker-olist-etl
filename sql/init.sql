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

COMMIT;
