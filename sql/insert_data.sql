INSERT INTO test_users (name, email, age) VALUES 
('Alice Johnson', 'alice.johnson@example.com', 28),
('Bob Smith', 'bob.smith@example.com', 34),
    ('Diana Prince', 'diana.prince@example.com', 31),
    ('Eve Wilson', 'eve.wilson@example.com', 29),
    ('Frank Miller', 'frank.miller@example.com', 45),
    ('Grace Kelly', 'grace.kelly@example.com', 33),
    ('Henry Ford', 'henry.ford@example.com', 38),
    ('Iris Chen', 'iris.chen@example.com', 26)
ON CONFLICT DO NOTHING;  -- avoid duplicate inserts if run multiple times

