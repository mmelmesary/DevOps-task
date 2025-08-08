# 🚀 Quick Start Guide - PostgreSQL Citus Cluster with HA

This guide will get your PostgreSQL Citus cluster with high availability up and running in minutes!

## 📋 Prerequisites

Before starting, ensure you have:
- ✅ Docker and Docker Compose installed
- ✅ Python 3.7+ installed
- ✅ At least 4GB RAM available
- ✅ Ports 5432, 5433, 5434, 5000, 7000, 8080, 2379 available

## 🎯 Step-by-Step Setup

### Step 1: Clone and Navigate
```bash
# If you have the files locally, navigate to the directory
cd "path/to/your/citus-cluster"

# Or if you need to create the files, ensure all files are in the same directory
ls -la
```

### Step 2: Start the Cluster
```bash
# Start all services
docker-compose up -d

# Check that all containers are running
docker-compose ps
```

### Step 3: Monitor Initialization
```bash
# Watch the logs during startup (this takes 2-3 minutes)
docker-compose logs -f

# You should see messages like:
# - "INFO: no action. I am (coordinator) the leader with the lock"
# - "INFO: no action. I am (worker1) a secondary and I am following a leader"
# - "INFO: no action. I am (worker2) a secondary and I am following a leader"
```

### Step 4: Install Python Dependencies
```bash
pip install -r requirements.txt
```

### Step 5: Verify Cluster Health
```bash
# Check Patroni cluster status
docker exec citus-coordinator patronictl list

# Expected output:
# +-------------+------------------+---------+---------+----+-----------+
# |   Cluster   |      Member     |  Host   |  Role   | TL | Lag in MB |
# +-------------+------------------+---------+---------+----+-----------+
# | citus-cluster | coordinator     | coordinator | Leader |  1 |           |
# | citus-cluster | worker1         | worker1     |        |  1 |       0.0 |
# | citus-cluster | worker2         | worker2     |        |  1 |       0.0 |
# +-------------+------------------+---------+---------+----+-----------+
```

## 🧪 Quick Test

### Option 1: Run the Comprehensive Test
```bash
python test_citus_cluster.py
```

### Option 2: Run the Demo
```bash
python demo_citus_cluster.py
```

### Option 3: Manual Testing
```bash
# Connect to the coordinator
docker exec -it citus-coordinator psql -U citus -d citus

# Create a test table
CREATE TABLE test_users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

# Make it distributed
SELECT create_distributed_table('test_users', 'id');

# Insert some data
INSERT INTO test_users (name, email) VALUES 
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com'),
    ('Charlie', 'charlie@example.com');

# Query the data
SELECT * FROM test_users;

# Check distribution
SELECT * FROM citus_tables;
```

## 🌐 Access Points

Once running, you can access:

| Service | URL | Credentials |
|---------|-----|-------------|
| **HAProxy Stats** | http://localhost:7000 | - |
| **pgAdmin** | http://localhost:8080 | admin@citus.com / admin123 |
| **Coordinator** | localhost:5432 | citus / citus123 |
| **Worker1** | localhost:5433 | citus / citus123 |
| **Worker2** | localhost:5434 | citus / citus123 |

## 🔍 Monitoring

### Check Cluster Health
```bash
# One-time health check
python monitor_cluster.py

# Continuous monitoring
python monitor_cluster.py --continuous
```

### View HAProxy Statistics
```bash
# Check load balancer stats
curl http://localhost:7000
```

## 🧪 Failure Testing

### Simulate Node Failures
```bash
# Test worker failure
python simulate_failure.py

# Or manually stop a worker
docker stop citus-worker1

# Check that the cluster remains functional
python test_citus_cluster.py
```

## 🛠️ Troubleshooting

### Common Issues

**1. Port Already in Use**
```bash
# Check what's using the ports
netstat -tulpn | grep :5432
# Stop conflicting services or change ports in docker-compose.yml
```

**2. Containers Not Starting**
```bash
# Check container logs
docker-compose logs coordinator
docker-compose logs worker1
docker-compose logs worker2

# Restart the cluster
docker-compose down
docker-compose up -d
```

**3. Connection Refused**
```bash
# Wait for full initialization (2-3 minutes)
docker-compose logs -f

# Check if Patroni is running
docker exec citus-coordinator patronictl list
```

**4. Python Connection Errors**
```bash
# Ensure dependencies are installed
pip install -r requirements.txt

# Check if cluster is ready
docker exec citus-coordinator patronictl list
```

### Reset Everything
```bash
# Stop and remove everything
docker-compose down -v

# Remove all data volumes
docker volume prune -f

# Start fresh
docker-compose up -d
```

## 📊 Verification Checklist

- [ ] All containers are running (`docker-compose ps`)
- [ ] Patroni cluster shows all nodes (`docker exec citus-coordinator patronictl list`)
- [ ] HAProxy stats page is accessible (http://localhost:7000)
- [ ] pgAdmin is accessible (http://localhost:8080)
- [ ] Python test script runs successfully (`python test_citus_cluster.py`)
- [ ] Failure simulation works (`python simulate_failure.py`)

## 🎉 Success!

If you've completed all the steps above, congratulations! You now have a fully functional PostgreSQL Citus cluster with high availability running.

### Next Steps
1. Explore the distributed query capabilities
2. Test different failure scenarios
3. Monitor performance metrics
4. Scale the cluster by adding more workers
5. Configure backup and recovery procedures

## 📚 Additional Resources

- [Citus Documentation](https://docs.citusdata.com/)
- [Patroni Documentation](https://patroni.readthedocs.io/)
- [HAProxy Documentation](https://www.haproxy.org/download/2.4/doc/)

---

**Need Help?** Check the main `README.md` for detailed architecture information and troubleshooting guides.
