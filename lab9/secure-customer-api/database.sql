CREATE DATABASE customer_management;
USE customer_management;

CREATE TABLE customers (
                           id BIGINT PRIMARY KEY AUTO_INCREMENT,
                           customer_code VARCHAR(20) UNIQUE NOT NULL,
                           full_name VARCHAR(100) NOT NULL,
                           email VARCHAR(100) UNIQUE NOT NULL,
                           phone VARCHAR(20),
                           address TEXT,
                           status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO customers (customer_code, full_name, email, phone, address, status) VALUES
                                                                                    ('C001', 'John Doe', 'john.doe@example.com', '+1-555-0101', '123 Main St, New York, NY 10001', 'ACTIVE'),
                                                                                    ('C002', 'Jane Smith', 'jane.smith@example.com', '+1-555-0102', '456 Oak Ave, Los Angeles, CA 90001', 'ACTIVE'),
                                                                                    ('C003', 'Bob Johnson', 'bob.johnson@example.com', '+1-555-0103', '789 Pine Rd, Chicago, IL 60601', 'ACTIVE'),
                                                                                    ('C004', 'Alice Brown', 'alice.brown@example.com', '+1-555-0104', '321 Elm St, Houston, TX 77001', 'INACTIVE'),
                                                                                    ('C005', 'Charlie Wilson', 'charlie.wilson@example.com', '+1-555-0105', '654 Maple Dr, Phoenix, AZ 85001', 'ACTIVE');

USE customer_management;

-- Users table
CREATE TABLE users (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       full_name VARCHAR(100) NOT NULL,
                       role ENUM('USER', 'ADMIN') DEFAULT 'USER',
                       is_active BOOLEAN DEFAULT TRUE,
                       reset_token VARCHAR(255) NULL,
                       reset_token_expiry TIMESTAMP NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

);

-- Login history table
CREATE TABLE login_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    login_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip_address VARCHAR(100),
    user_agent VARCHAR(500),
    CONSTRAINT fk_login_history_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Sample users (password: "password123" hashed with BCrypt)
INSERT INTO users (username, email, password, full_name, role, is_active) VALUES
                                                                              ('admin', 'admin@example.com', '$2a$10$XptfskLsT1l/bRTLRiiCgejHqOpgXFreUnNUa35gJdCr2v2QbVFzu', 'Admin User', 'ADMIN', true),
                                                                              ('john', 'john@example.com', '$2a$10$XptfskLsT1l/bRTLRiiCgejHqOpgXFreUnNUa35gJdCr2v2QbVFzu', 'John Doe', 'USER', true),
                                                                              ('jane', 'jane@example.com', '$2a$10$XptfskLsT1l/bRTLRiiCgejHqOpgXFreUnNUa35gJdCr2v2QbVFzu', 'Jane Smith', 'USER', true);

-- Refresh tokens table
CREATE TABLE refresh_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    token VARCHAR(255) UNIQUE NOT NULL,
    expiry_date TIMESTAMP NOT NULL,
    CONSTRAINT fk_refresh_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);