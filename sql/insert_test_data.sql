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

-- Insert orders data (if orders table exists)
INSERT INTO test_orders (user_id, product_name, quantity, price, order_date) VALUES 
    (1, 'Laptop', 1, 1299.99, '2024-01-15'),
    (2, 'Mouse', 2, 29.99, '2024-01-16'),
    (3, 'Keyboard', 1, 89.99, '2024-01-17'),
    (4, 'Monitor', 1, 299.99, '2024-01-18'),
    (5, 'Headphones', 1, 149.99, '2024-01-19'),
    (6, 'Webcam', 1, 79.99, '2024-01-20'),
    (7, 'USB Drive', 3, 19.99, '2024-01-21'),
    (8, 'External HDD', 1, 89.99, '2024-01-22'),
    (9, 'Wireless Router', 1, 129.99, '2024-01-23'),
    (10, 'Gaming Mouse', 1, 69.99, '2024-01-24');

-- Insert more test data for performance testing
INSERT INTO test_users (name, email, age) VALUES 
    ('Kate Williams', 'kate.williams@test.org', 27),
    ('Liam O\'Connor', 'liam.oconnor@test.org', 35),
    ('Maya Patel', 'maya.patel@test.org', 30),
    ('Noah Garcia', 'noah.garcia@test.org', 39),
    ('Olivia Taylor', 'olivia.taylor@test.org', 32),
    ('Paul Anderson', 'paul.anderson@test.org', 44),
    ('Quinn Martinez', 'quinn.martinez@test.org', 28),
    ('Rachel Lee', 'rachel.lee@test.org', 36),
    ('Sam Thompson', 'sam.thompson@test.org', 31),
    ('Tina Rodriguez', 'tina.rodriguez@test.org', 29);

-- Insert corresponding orders
INSERT INTO test_orders (user_id, product_name, quantity, price, order_date) VALUES 
    (11, 'Tablet', 1, 499.99, '2024-01-25'),
    (12, 'Bluetooth Speaker', 2, 59.99, '2024-01-26'),
    (13, 'Smart Watch', 1, 199.99, '2024-01-27'),
    (14, 'Power Bank', 1, 39.99, '2024-01-28'),
    (15, 'Wireless Earbuds', 1, 89.99, '2024-01-29'),
    (16, 'Portable SSD', 1, 129.99, '2024-01-30'),
    (17, 'Mechanical Keyboard', 1, 149.99, '2024-01-31'),
    (18, 'Gaming Headset', 1, 79.99, '2024-02-01'),
    (19, 'Webcam HD', 1, 99.99, '2024-02-02'),
    (20, 'Wireless Charger', 1, 49.99, '2024-02-03');
