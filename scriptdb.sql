-- PostgreSQL in Docker will use the database specified by POSTGRES_DB
-- No need to create or connect to the database explicitly

-- Create the category table
CREATE TABLE IF NOT EXISTS CATEGORY(
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- Insert default categories
INSERT INTO CATEGORY(name) VALUES 
    ('Fruits'),
    ('Vegetables'),
    ('Meat'),
    ('Fish'),
    ('Dairy'),
    ('Bakery'),
    ('Drinks'),
    ('Sweets'),
    ('Other');

-- Create the customer table
CREATE TABLE IF NOT EXISTS CUSTOMER(
    id SERIAL PRIMARY KEY,
    address VARCHAR(255),
    email VARCHAR(255),
    password VARCHAR(255),
    role VARCHAR(255),
    username VARCHAR(255) UNIQUE
);

-- Insert default customers
INSERT INTO CUSTOMER(address, email, password, role, username) VALUES
    ('123, Albany Street', 'admin@nyan.cat', '123', 'ROLE_ADMIN', 'admin'),
    ('765, 5th Avenue', 'lisa@gmail.com', '765', 'ROLE_NORMAL', 'lisa')
ON CONFLICT (username) DO NOTHING;

-- Create the product table
CREATE TABLE IF NOT EXISTS PRODUCT(
    product_id SERIAL PRIMARY KEY,
    description VARCHAR(255),
    image VARCHAR(255),
    name VARCHAR(255),
    price INTEGER,
    quantity INTEGER,
    weight INTEGER,
    category_id INTEGER,
    customer_id INTEGER
);

-- Insert default products
INSER
