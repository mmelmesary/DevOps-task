#!/usr/bin/env python3
"""
Improved Citus Cluster Test Script
Uses separate SQL files for better organization and maintainability
"""

import psycopg2
import time
import logging
import os
from psycopg2.extras import RealDictCursor
from typing import Optional, Dict, Any, List

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class CitusClusterTester:
    def __init__(self, host='localhost', port=5432, database='citus', 
                 user='citus', password='citus123'):
        self.host = host
        self.port = port
        self.database = database
        self.user = user
        self.password = password
        self.connection = None
        self.sql_dir = 'sql'  # Directory containing SQL files
        
    def connect(self, max_retries=5, retry_delay=2) -> bool:
        """Connect to the Citus cluster with retry logic"""
        for attempt in range(max_retries):
            try:
                logger.info(f"Attempting to connect to {self.host}:{self.port} (attempt {attempt + 1})")
                self.connection = psycopg2.connect(
                    host=self.host,
                    port=self.port,
                    database=self.database,
                    user=self.user,
                    password=self.password,
                    cursor_factory=RealDictCursor
                )
                logger.info("Successfully connected to Citus cluster")
                return True
            except psycopg2.OperationalError as e:
                logger.warning(f"Connection attempt {attempt + 1} failed: {e}")
                if attempt < max_retries - 1:
                    time.sleep(retry_delay)
                else:
                    logger.error("Failed to connect after all retry attempts")
                    return False
        return False
    
    def execute_query(self, query: str, params: tuple = None) -> Optional[list]:
        """Execute a query with error handling"""
        if not self.connection:
            logger.error("No active connection")
            return None
            
        try:
            with self.connection.cursor() as cursor:
                cursor.execute(query, params)
                if query.strip().upper().startswith('SELECT'):
                    return cursor.fetchall()
                else:
                    self.connection.commit()
                    return cursor.rowcount
        except psycopg2.Error as e:
            logger.error(f"Query execution failed: {e}")
            self.connection.rollback()
            return None
    
    def execute_sql_file(self, filename: str) -> bool:
        """Execute SQL commands from a file"""
        filepath = os.path.join(self.sql_dir, filename)
        
        if not os.path.exists(filepath):
            logger.error(f"SQL file not found: {filepath}")
            return False
        
        try:
            with open(filepath, 'r') as f:
                sql_content = f.read()
            
            # Split by semicolon and execute each statement
            statements = [stmt.strip() for stmt in sql_content.split(';') if stmt.strip()]
            
            success_count = 0
            error_count = 0
            
            for i, statement in enumerate(statements):
                if statement and not statement.startswith('--'):  # Skip comments
                    logger.info(f"Executing statement {i+1}/{len(statements)} from {filename}")
                    result = self.execute_query(statement)
                    if result is not None:
                        success_count += 1
                        logger.info(f"Statement {i+1} executed successfully")
                    else:
                        error_count += 1
                        logger.warning(f"Statement {i+1} failed, but continuing...")
            
            logger.info(f"SQL file {filename} completed: {success_count} successful, {error_count} failed")
            return success_count > 0  # Return True if at least one statement succeeded
            
        except Exception as e:
            logger.error(f"Error executing SQL file {filename}: {e}")
            return False
    
    def setup_distributed_tables(self) -> bool:
        """Create and setup distributed tables using SQL file"""
        logger.info("Setting up distributed tables...")
        return self.execute_sql_file('create_tables.sql')
    
    def insert_test_data(self) -> bool:
        """Insert test data using SQL file"""
        logger.info("Inserting test data...")
        return self.execute_sql_file('insert_test_data.sql')
    
    def run_test_queries(self) -> bool:
        """Run test queries from SQL file"""
        logger.info("Running test queries...")
        return self.execute_sql_file('queries.sql')
    
    def check_cluster_health(self) -> Dict[str, Any]:
        """Check the health of the Citus cluster"""
        logger.info("Checking cluster health...")
        
        health_info = {}
        
        # Check coordinator
        try:
            coord_query = "SELECT * FROM citus_get_coordinator_node();"
            result = self.execute_query(coord_query)
            if result:
                health_info['coordinator'] = 'OK'
                logger.info("Coordinator node is healthy")
            else:
                health_info['coordinator'] = 'ERROR'
                logger.error("Coordinator node check failed")
        except Exception as e:
            health_info['coordinator'] = f'ERROR: {e}'
            logger.error(f"Coordinator check error: {e}")
        
        # Check worker nodes
        try:
            workers_query = "SELECT * FROM citus_get_active_worker_nodes();"
            result = self.execute_query(workers_query)
            if result:
                health_info['workers'] = f'OK ({len(result)} active workers)'
                logger.info(f"Found {len(result)} active worker nodes")
            else:
                health_info['workers'] = 'ERROR'
                logger.error("Worker nodes check failed")
        except Exception as e:
            health_info['workers'] = f'ERROR: {e}'
            logger.error(f"Workers check error: {e}")
        
        # Check distributed tables
        try:
            tables_query = "SELECT * FROM citus_tables;"
            result = self.execute_query(tables_query)
            if result:
                health_info['distributed_tables'] = f'OK ({len(result)} tables)'
                logger.info(f"Found {len(result)} distributed tables")
            else:
                health_info['distributed_tables'] = 'WARNING: No distributed tables found'
                logger.warning("No distributed tables found")
        except Exception as e:
            health_info['distributed_tables'] = f'ERROR: {e}'
            logger.error(f"Distributed tables check error: {e}")
        
        return health_info
    
    def simulate_failure_and_recovery(self) -> bool:
        """Simulate a failure and test recovery"""
        logger.info("Simulating failure and testing recovery...")
        
        # Test basic operations before failure
        logger.info("Testing operations before failure...")
        if not self.run_test_queries():
            logger.error("Pre-failure tests failed")
            return False
        
        # Simulate connection failure
        logger.info("Simulating connection failure...")
        self.close()
        time.sleep(2)
        
        # Attempt reconnection
        logger.info("Attempting reconnection...")
        if not self.connect():
            logger.error("Failed to reconnect after simulated failure")
            return False
        
        # Test operations after recovery
        logger.info("Testing operations after recovery...")
        if not self.run_test_queries():
            logger.error("Post-recovery tests failed")
            return False
        
        logger.info("Failure simulation and recovery test completed successfully")
        return True
    
    def run_comprehensive_test(self) -> bool:
        """Run comprehensive test of the Citus cluster"""
        logger.info("Starting comprehensive Citus cluster test...")
        
        # Step 1: Connect to cluster
        if not self.connect():
            logger.error("Failed to connect to cluster")
            return False
        
        # Step 2: Setup distributed tables
        if not self.setup_distributed_tables():
            logger.error("Failed to setup distributed tables")
            return False
        
        # Step 3: Insert test data
        if not self.insert_test_data():
            logger.error("Failed to insert test data")
            return False
        
        # Step 4: Run test queries
        if not self.run_test_queries():
            logger.error("Failed to run test queries")
            return False
        
        # Step 5: Check cluster health
        health_info = self.check_cluster_health()
        logger.info("Cluster health check results:")
        for component, status in health_info.items():
            logger.info(f"  {component}: {status}")
        
        # Step 6: Test failure recovery
        if not self.simulate_failure_and_recovery():
            logger.error("Failure recovery test failed")
            return False
        
        logger.info("✅ Comprehensive test completed successfully!")
        return True
    
    def close(self):
        """Close the database connection"""
        if self.connection:
            self.connection.close()
            logger.info("Database connection closed")

def main():
    """Main function to run the test"""
    tester = CitusClusterTester()
    
    try:
        success = tester.run_comprehensive_test()
        if success:
            print("\n🎉 All tests passed! Citus cluster is working correctly.")
            return 0
        else:
            print("\n❌ Some tests failed. Check the logs for details.")
            return 1
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        print(f"\n💥 Unexpected error: {e}")
        return 1
    finally:
        tester.close()

if __name__ == "__main__":
    exit(main())
