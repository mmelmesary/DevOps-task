-- Test queries for distributed tables
-- This file contains SQL queries to test and verify distributed data

-- 1. Basic count queries
SELECT COUNT(*) as total_users FROM test_users;

-- 2. Age distribution analysis
SELECT 
    CASE 
        WHEN age < 25 THEN '18-24'
        WHEN age < 35 THEN '25-34'
        WHEN age < 45 THEN '35-44'
        WHEN age < 55 THEN '45-54'
        ELSE '55+'
    END as age_group,
    COUNT(*) as user_count,
    AVG(age) as avg_age
FROM test_users
GROUP BY age_group
ORDER BY age_group;

-- 3. Check data distribution across shards
SELECT 
    citus_shard_id,
    COUNT(*) as record_count
FROM test_users
GROUP BY citus_shard_id
ORDER BY citus_shard_id;

-- 4. Cluster health check
SELECT 
    'Citus Tables' as info_type,
    schemaname,
    tablename,
    tableowner
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename LIKE 'test_%'
ORDER BY tablename;

-- 5. Check active worker nodes
SELECT * FROM citus_get_active_worker_nodes();

-- 6. Check distributed tables
SELECT * FROM citus_tables;
