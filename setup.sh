#!/bin/bash

# Citus Cluster HA Setup Script
# This script sets up a PostgreSQL Citus cluster with high availability

set -e

echo "🚀 Setting up PostgreSQL Citus Cluster with HA..."

# Check prerequisites
echo "📋 Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p logs
mkdir -p data

# Set proper permissions
chmod +x test_citus_cluster.py

# Start the cluster
echo "🐳 Starting Citus cluster..."
docker-compose up -d

echo "⏳ Waiting for cluster initialization..."
echo "This may take 2-3 minutes. You can monitor progress with: docker-compose logs -f"

# Wait for etcd to be ready
echo "Waiting for etcd to be ready..."
sleep 30

# Wait for Patroni cluster to form
echo "Waiting for Patroni cluster to form..."
sleep 60

# Check cluster status
echo "🔍 Checking cluster status..."
sleep 30

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install -r requirements.txt

echo "✅ Setup completed!"
echo ""
echo "📊 Access Points:"
echo "  - HAProxy Stats: http://localhost:7000"
echo "  - pgAdmin: http://localhost:8080 (admin@citus.com / admin123)"
echo "  - Coordinator: localhost:5432"
echo "  - Worker1: localhost:5433"
echo "  - Worker2: localhost:5434"
echo ""
echo "🧪 To test the cluster, run:"
echo "  python test_citus_cluster.py"
echo ""
echo "📋 To monitor the cluster:"
echo "  docker-compose logs -f"
echo ""
echo "🛑 To stop the cluster:"
echo "  docker-compose down"
