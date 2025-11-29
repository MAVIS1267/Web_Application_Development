CREATE DATABASE IF NOT EXISTS product_management;
USE product_management;

CREATE TABLE IF NOT EXISTS products (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    quantity INT DEFAULT 0,
    category VARCHAR(50),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO products (product_code, name, price, quantity, category, description) VALUES
('P001', 'Laptop Dell XPS 13', 1299.99, 10, 'Electronics', 'High-performance laptop'),
('P002', 'iPhone 15 Pro', 999.99, 25, 'Electronics', 'Latest iPhone model'),
('P003', 'Office Chair', 199.99, 50, 'Furniture', 'Ergonomic office chair');
