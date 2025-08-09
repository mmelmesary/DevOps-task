-- Register workers with the coordinator
SELECT * FROM master_add_node('worker1', 5432);
SELECT * FROM master_add_node('worker2', 5432);