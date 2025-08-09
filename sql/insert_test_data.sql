-- Insert test data into distributed tables
-- This file contains SQL statements to populate test data

-- Insert users data
INSERT INTO test_users (name, email, age) VALUES 
    ('Alice Johnson', 'alice.johnson@example.com', 28),
    ('Bob Smith', 'bob.smith@example.com', 34),
    ('Charlie Brown', 'charlie.brown@example.com', 42),
    ('Diana Prince', 'diana.prince@example.com', 31),
    ('Eve Wilson', 'eve.wilson@example.com', 29),
    ('Frank Miller', 'frank.miller@example.com', 45),
    ('Grace Kelly', 'grace.kelly@example.com', 33),
    ('Henry Ford', 'henry.ford@example.com', 38),
    ('Iris Chen', 'iris.chen@example.com', 26),
    ('Jack Davis', 'jack.davis@example.com', 41);

-- Insert products data
INSERT INTO test_products (name, category, price, stock_quantity) VALUES 
    ('Laptop', 'Electronics', 1299.99, 10),
    ('Mouse', 'Electronics', 29.99, 50),
    ('Keyboard', 'Electronics', 89.99, 25),
    ('Monitor', 'Electronics', 299.99, 15),
    ('Headphones', 'Electronics', 149.99, 30),
    ('Webcam', 'Electronics', 79.99, 20),
    ('USB Drive', 'Electronics', 19.99, 100),
    ('External HDD', 'Electronics', 89.99, 12),
    ('Wireless Router', 'Electronics', 129.99, 8),
    ('Gaming Mouse', 'Electronics', 69.99, 35);

-- Insert more test data for performance testing
INSERT INTO test_users (name, email, age) VALUES 
    ('Kate Williams', 'kate.williams@test.org', 27),
    ('Liam OConnor', 'liam.oconnor@test.org', 35),
    ('Maya Patel', 'maya.patel@test.org', 30),
    ('Noah Garcia', 'noah.garcia@test.org', 39),
    ('Olivia Taylor', 'olivia.taylor@test.org', 32),
    ('Paul Anderson', 'paul.anderson@test.org', 44),
    ('Quinn Martinez', 'quinn.martinez@test.org', 28),
    ('Rachel Lee', 'rachel.lee@test.org', 36),
    ('Sam Thompson', 'sam.thompson@test.org', 31),
    ('Tina Rodriguez', 'tina.rodriguez@test.org', 29);

-- Insert more products
INSERT INTO test_products (name, category, price, stock_quantity) VALUES 
    ('Tablet', 'Electronics', 499.99, 15),
    ('Bluetooth Speaker', 'Electronics', 59.99, 40),
    ('Smart Watch', 'Electronics', 199.99, 25),
    ('Power Bank', 'Electronics', 39.99, 60),
    ('Wireless Earbuds', 'Electronics', 89.99, 45),
    ('Portable SSD', 'Electronics', 129.99, 20),
    ('Mechanical Keyboard', 'Electronics', 149.99, 18),
    ('Gaming Headset', 'Electronics', 79.99, 30),
    ('Webcam HD', 'Electronics', 99.99, 22),
    ('Wireless Charger', 'Electronics', 49.99, 55);
