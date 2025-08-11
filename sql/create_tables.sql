-- Create distributed tables for Citus cluster

CREATE TABLE IF NOT EXISTS test_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    age INTEGER CHECK (age >= 0 AND age <= 120),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

SELECT create_distributed_table('test_users', 'id') 
    WHERE NOT EXISTS (
        SELECT 1 FROM citus_tables WHERE table_name = 'test_users'::regclass
    );
