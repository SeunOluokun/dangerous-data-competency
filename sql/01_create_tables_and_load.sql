-- use schema
USE dangerous_data_competency;

-- Drop in dependency order (child tables first)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- -----------------------------
-- 1) Create tables
-- -----------------------------
CREATE TABLE customers 
(
	CUSTOMER_ID INT NOT NULL,
	SIGNUP_DATE DATETIME NULL,
	COUNTRY VARCHAR(50) NULL,
	ACQUISITION_CHANNEL VARCHAR(100) NULL,
	PRIMARY KEY (CUSTOMER_ID)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
;
-- I used InnoDB to support foreign key constraints and ensure data integrity, and utf8mb4 to safely handle all text data without encoding issues.

CREATE TABLE products 
(
	  product_id INT NOT NULL,
	  product_name VARCHAR(150) NULL,
	  product_category VARCHAR(100) NULL,
	  PRIMARY KEY (product_id)
) 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE orders 
(
	  order_id INT NOT NULL,
	  customer_id INT NOT NULL,
	  order_date DATETIME NULL,
	  order_status VARCHAR(50) NULL,
	  PRIMARY KEY (order_id),
	  CONSTRAINT fk_orders_customer
		FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
) 
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE order_items (
  order_item_id INT NOT NULL AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NULL,
  unit_price DECIMAL(10,2) NULL,
  PRIMARY KEY (order_item_id),
  KEY idx_order_items_order_id (order_id),
  KEY idx_order_items_product_id (product_id),
  CONSTRAINT fk_items_order
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_items_product
    FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- -----------------------------
-- 2) Load data from CSVs
-- -----------------------------
LOAD DATA LOCAL INFILE '/Users/oluwaseunoluokun/Documents/Data_Journals/dangerous-data-competency/data/processed/customers_cleaned.csv'
INTO TABLE dangerous_data_competency.customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE '/Users/oluwaseunoluokun/Documents/Data_Journals/dangerous-data-competency/data/processed/orders_cleaned.csv'
INTO TABLE dangerous_data_competency.orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/oluwaseunoluokun/Documents/Data_Journals/dangerous-data-competency/data/processed/products_cleaned.csv'
INTO TABLE dangerous_data_competency.products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/oluwaseunoluokun/Documents/Data_Journals/dangerous-data-competency/data/processed/order_items_cleaned.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, product_id, quantity, unit_price);

-- -----------------------------
-- 3) Validate loads
-- -----------------------------
SELECT COUNT(*) AS customers_rows FROM customers;
SELECT COUNT(*) AS products_rows FROM products;
SELECT COUNT(*) AS orders_rows FROM orders;
SELECT COUNT(*) AS order_items_rows FROM order_items;

SELECT * FROM customers LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM order_items LIMIT 5;

----------------------------------
-- Check Count matches Excel Count
----------------------------------
SELECT
(SELECT COUNT(*) FROM customers) AS customers_rows ,
(SELECT COUNT(*) FROM products) AS products_rows ,
(SELECT COUNT(*) FROM orders) AS orders_rows ,
(SELECT COUNT(*) FROM order_items) AS order_items_rows 
;

