-----Amazon Project ---Advanced SQL---------

DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS shippings;
DROP TABLE IF EXISTS inventory;

----Creating table for category----

CREATE TABLE category
(
	category_id INT PRIMARY KEY,
	category_name VARCHAR(25)
);

----Creating a customers table---
CREATE TABLE customers
( 
	customer_id INT PRIMARY KEY,
	first_name VARCHAR(25),	
	last_name VARCHAR(25),	
	state VARCHAR(25),
	address VARCHAR(5) DEFAULT ('xxxx')
);

---Creating seller table----

CREATE TABLE sellers
(	
	seller_id INT PRIMARY KEY,
	seller_name VARCHAR(55),
	origin VARCHAR(15)

);

----Creating product table---

CREATE TABLE products
(
	product_id INT PRIMARY KEY,
	product_name VARCHAR(100),
	price FLOAT,
	cogs FLOAT,
	category_id INT, ---- FK comming from category table
	CONSTRAINT products_fk_category FOREIGN KEY(category_id) 
	REFERENCES category(category_id)
);

---Creating the order table---
CREATE TABLE orders
(
	order_id INT PRIMARY KEY,
	order_date DATE,
	customer_id INT, ---FK comming from customers table
	seller_id INT, ---->Fk comming from seller table
	order_status varchar(25),
	CONSTRAINT orders_fk_customers FOREIGN KEY(customer_id)
	REFERENCES customers(customer_id),
	CONSTRAINT orders_fk_sellers FOREIGN KEY(seller_id)
	REFERENCES sellers(seller_id)
);

--Creating the  Order_items table---
CREATE TABLE order_items
(
	order_item_id INT PRIMARY KEY,
	order_id INT,---FK comming from the orders table
	product_id INT, ---FK comming from the products table
	quantity INT, 
	price_per_unit FLOAT,
	CONSTRAINT order_items_fk_orders FOREIGN KEY(order_id)
	REFERENCES orders(order_id),
	CONSTRAINT order_items_fk_products FOREIGN KEY(product_id)
	REFERENCES products(product_id)
	
);

--Creating the  Payments table---

CREATE TABLE payments
(
	payment_id INT PRIMARY KEY,
	order_id INT,---->FK comming from the orders table
	payment_date Date,
	payment_status VARCHAR(25),
	CONSTRAINT payments_fk_orders FOREIGN KEY(order_id)
	REFERENCES orders(order_id)
	
);
--Creating the Shipping table---
CREATE TABLE shippings
(
	shipping_id INT PRIMARY KEY,
	order_id INT,-----FK comming from the orders table
	shipping_date DATE,
	return_date DATE,
	shipping_providers VARCHAR(55),
	delivery_status VARCHAR(25),
	CONSTRAINT shippings_fk_orders FOREIGN KEY(order_id)
	REFERENCES orders(order_id)	
);

--Creating the Inventory table---

CREATE TABLE inventory
(
	inventory_id INT PRIMARY KEY,
	product_id INT, ---> fk comming from producs table
	stock INT,
	warehouse_id INT,
	last_stock_date DATE,
	CONSTRAINT inventory_fk_products FOREIGN KEY(product_id)
	REFERENCES products(product_id)
);

























