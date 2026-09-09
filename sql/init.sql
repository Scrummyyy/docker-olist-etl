BEGIN;

-- ==========================================
-- 1. Creating products dataset with its parameters
-- ==========================================

CREATE TABLE IF NOT EXISTS olist_products_dataset (
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

COMMIT;