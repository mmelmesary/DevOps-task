-- Create distributed tables for Citus cluster
-- This file contains SQL statements to create and distribute tables

-- Create users table
CREATE TABLE IF NOT EXISTS test_users (
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INTEGER CHECK (age >= 0 AND age <= 120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE IF NOT EXISTS test_orders (
    id SERIAL,
    user_id INTEGER NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

-- Create products table
CREATE TABLE IF NOT EXISTS test_products (
    id SERIAL,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Distribute tables across worker nodes
-- Users table distributed by id (hash distribution)
SELECT create_distributed_table('test_users', 'id');

-- Orders table distributed by user_id (hash distribution)
SELECT create_distributed_table('test_orders', 'user_id');

-- Products table distributed by id (hash distribution)
SELECT create_distributed_table('test_products', 'id');
