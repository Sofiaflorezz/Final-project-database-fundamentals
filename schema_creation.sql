CREATE DATABASE order_management;
USE order_management;

CREATE TABLE Customer (
    customer_id INT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    customer_lastname VARCHAR(50) NOT NULL,
    customer_email VARCHAR(50) UNIQUE NOT NULL,
    customer_address VARCHAR(100),
    customer_phone VARCHAR(20),
    registration_date TIMESTAMP NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE Manager (
    manager_id INT NOT NULL,
    manager_name VARCHAR(50) NOT NULL,
    manager_lastname VARCHAR(50) NOT NULL,
    manager_email VARCHAR(50) UNIQUE NOT NULL,
    manager_phone VARCHAR(20),
    store_id INT NOT NULL,
    PRIMARY KEY (manager_id)
);

CREATE TABLE Category (
    category_id INT NOT NULL,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    category_description VARCHAR(200),
    PRIMARY KEY (category_id)
);

CREATE TABLE Store (
    store_id INT NOT NULL,
    store_name VARCHAR(50) NOT NULL,
    store_address VARCHAR(100),
    store_phone VARCHAR(20),
    store_email VARCHAR(50) UNIQUE NOT NULL,
    PRIMARY KEY (store_id)
);

CREATE TABLE Product (
    product_id INT NOT NULL,
    product_name VARCHAR(50) UNIQUE NOT NULL,
    product_price FLOAT NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id),
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

CREATE TABLE Store_Product (
    store_id INT NOT NULL,
    product_id INT NOT NULL,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES Store(store_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Orderr (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    store_id INT NOT NULL,
    order_status VARCHAR(20),
    order_date TIMESTAMP NOT NULL,
    total_order FLOAT NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE Ordered_Item (
    ordered_item_id INT NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price FLOAT NOT NULL,
    PRIMARY KEY (ordered_item_id),
    FOREIGN KEY (order_id) REFERENCES Orderr(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

CREATE TABLE Transactionn (
    transaction_id VARCHAR(36) PRIMARY KEY,
    order_id INT NOT NULL,
    transaction_date TIMESTAMP NOT NULL,
    total_amount FLOAT NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orderr(order_id)
);

CREATE TABLE Delivery (
    delivery_id INT NOT NULL,
    order_id INT NOT NULL,
    delivery_address VARCHAR(100),
    delivery_date TIMESTAMP NOT NULL,
    delivery_instructions VARCHAR(200),
    PRIMARY KEY (delivery_id),
    FOREIGN KEY (order_id) REFERENCES Orderr(order_id)
);