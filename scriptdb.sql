-- SQL configs
-- (In PostgreSQL, set configs separately if needed. No direct equivalent for SQL_MODE.)

-- create database and use it
CREATE DATABASE if not exists ecommjava;
\c ecommjava -- Connect to the database (PostgreSQL way)

-- create the category table
CREATE TABLE IF NOT EXISTS CATEGORY (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(255)
);

-- insert default categories
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

-- create the customer table
CREATE TABLE IF NOT EXISTS CUSTOMER (
    id       SERIAL PRIMARY KEY,
    address  VARCHAR(255),
    email    VARCHAR(255),
    password VARCHAR(255),
    role     VARCHAR(255),
    username VARCHAR(255) UNIQUE
);

-- insert default customers
INSERT INTO CUSTOMER(address, email, password, role, username) VALUES
    ('123, Albany Street', 'admin@nyan.cat', '123', 'ROLE_ADMIN', 'admin'),
    ('765, 5th Avenue', 'lisa@gmail.com', '765', 'ROLE_NORMAL', 'lisa');

-- create the product table
CREATE TABLE IF NOT EXISTS PRODUCT (
    product_id  SERIAL PRIMARY KEY,
    description VARCHAR(255),
    image       VARCHAR(255),
    name        VARCHAR(255),
    price       INT,
    quantity    INT,
    weight      INT,
    category_id INT REFERENCES CATEGORY(category_id),
    customer_id INT REFERENCES CUSTOMER(id)
);

-- insert default products
INSERT INTO PRODUCT(description, image, name, price, quantity, weight, category_id) VALUES
    ('Fresh and juicy', 'https://freepngimg.com/save/9557-apple-fruit-transparent/744x744', 'Apple', 3, 40, 76, 1),
    ('Woops! There goes the eggs...', 'https://www.nicepng.com/png/full/813-8132637_poiata-bunicii-cracked-egg.png', 'Cracked Eggs', 1, 90, 43, 9);

-- indexes are created automatically by the FOREIGN KEY constraints
-- but if you still want manual indexes:
CREATE INDEX idx_product_category_id ON PRODUCT (category_id);
CREATE INDEX idx_product_customer_id ON PRODUCT (customer_id);
