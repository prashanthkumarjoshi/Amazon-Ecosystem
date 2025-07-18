-----EDA-----
select * from category;
select * from customers;
select * from products;
select * from shippings;
select * from payments;
select * from sellers;
select * from orders;
select * from order_items;
select * from inventory;

select distinct	payment_status from payments;

SELECT * FROM shippings where return_date is not null;

Select * from orders where order_id  =6747;

Select * from payments where order_id  =6747;

SELECT * FROM shippings where return_date is null;

-------------------------------------------------------
-----------------BUSINES PROBLEMS----------------------
-----------------ADVANCE ANALYSIS----------------------
--------------------------------------------------------


--Q1 Top Selling Products by Total Sales Query the Top 10 Products
--by Total sales value. Challenge: Include Product name, 
--total quantity sold, and total sales value

---- creating new column--

ALTER TABLE order_items
ADD COLUMN total_sale FLOAT;

--- updating total_sale by multiplying price and qunatity--
UPDATE order_items
SET total_sale = quantity * price_per_unit;


SELECT 
	oi.product_id,
	p.product_name,
	SUM(oi.total_sale) AS total_sale,
COUNT(o.order_id) AS total_orders 
FROM
	orders o
JOIN order_items oi on oi.order_id = o.order_id
JOIN products p on  p.product_id = oi.product_id
GROUP BY
	1,
	2
ORDER BY 3 DESC
LIMIT 10

-------
--Q2 Revenue Breakdown by Product Category 
--Calculate total revenue generated by each product category. Challenge: 
--Include the percentage 
--contribution of each category to total revenue

SELECT 
	p.category_id,
	c.category_name,
 	SUM(oi.total_sale) total_sale,
    SUM(oi.total_sale) / 
	(SELECT SUM(total_sale) FROM order_items) * 100
	AS revenue_contribution	
FROM 
	orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category c ON c.category_id = p.category_id
GROUP BY
	1,
	2
ORDER BY
	3 DESC;

--Q3
--Average Order Value for Customers with More Than 5 Orders
--Compute the average Order value for each customer Challenge:
--Include Only the Customers with more than 5 Orders

SELECT 
	c.customer_id,
	concat(c.first_name,' ',c.last_name) as customer_name,
	sum(oi.total_sale)/count(o.order_id) as average_order_value
	
FROM
	orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id

GROUP BY
	1,
	2
HAVING
	count(o.order_id)>=5

--q4 Monthly Sales Trend for the Previous  Years
--Query Monthly Total Sales Over the Past year's. 
--Challenge: Display the sales trend, grouping by month,
--return current_month_sales, Last Month Sales

WITH mothly_sales_trend as(

SELECT 
	EXTRACT(YEAR FROM o.order_date) AS year,
	EXTRACT(MONTH FROM o.order_date) AS month,
	ROUND(SUM(oi.total_sale)::NUMERIC,2) AS current_month_sale
FROM
	orders o 
JOIN order_items oi ON o.order_id = oi.order_id
--WHERE o.order_date = current_date - INTERVAL '1 year'
GROUP BY
	1,
	2
ORDER BY
	2,
	3
)
SELECT 
	year,
	month,
	current_month_sale, 
	LAG(SUM(current_month_sale),1) 
	OVER(ORDER BY year,month) as previous_year_sale
FROM mothly_sales_trend
GROUP BY
	1,
	2,
	3;

--q5 Customers Registered but Never Made a Purchase
--Find the Customer registered but never 
--placed an order Challenge: List customer details and 
--the time since their registration.

--APPROACH_1---

SELECT c.customer_id,
		concat(first_name,' ', last_name) as full_name
FROM customers C

WHERE customer_ID IN

(SELECT
	distinct c.customer_id	
FROM
	customers c

LEFT JOIN orders o on c.customer_id= o.customer_id
WHERE order_id IS NULL
group by
	1
)
ORDER BY 1;

---APPROACH_2---

SELECT * 

FROM customers

WHERE customer_id IN

(SELECT
	distinct c.customer_id	
FROM
	customers c

LEFT JOIN orders o on c.customer_id= o.customer_id
GROUP BY
	1
HAVING
	COUNT(o.order_id) =0
)
	

--APPROACH_3---
SELECT * FROM customers

WHERE customer_id NOT IN
(SELECT DISTINCT customer_id FROM orders)
	ORDER BY customer_id


--q6 Best Selling Category by State
--Identify the best-selling product for each state 
--Challenge: Include the Total 
--Sales for that category within each State.
/*
I have identified the Top 3 categories for each state to provide a focused analysis of the 
most significant contributors. Notably, the Electronics category accounts for approximately 
89% of total sales, which highlights its dominant impact. This analysis allows stakeholders
to make informed decisions based on the Top 3 categories, or expand the scope to the Top 5 
or Top 10 categories if needed, depending on their strategic preferences */

Select * from category
select distinct state from customers
select * from orders
select * from order_items

WITH Best_selling_category AS

(SELECT 
	c.state as state,
	ca.category_name as category,
	ROUND(sum(oi.total_sale)::NUMERIC,2) as total_sale,
	RANK() OVER(PARTITION BY c.state ORDER BY SUM(oi.total_sale) DESC) as rank
FROM 
	orders o
LEFT JOIN order_items oi on oi.order_id = o.order_id
LEFT JOIN customers c on o.customer_id = c.customer_id
LEFT JOIN  products p on p.product_id = oi.product_id
LEFT JOIN category ca on ca.category_id = p.category_id
GROUP BY
	1,
	2
)
SELECT state, category,total_sale, rank FROM best_selling_category
WHERE rank = 1
ORDER BY
	1,
	2

--q7 Customer Lifetime Value (CLV) Ranking
--Calculate the total value of orders placed by each customer
--over their lifetime. 
--Challenge: Rank customers based on their Customer Lifetime Sales

SELECT 
	o.customer_id,
	concat(first_name,' ', last_name) as customer_name,
	--COUNT(oi.order_id),
	ROUND(SUM(oi.total_sale)::NUMERIC,2) as total_value,
	DENSE_RANK() OVER(ORDER BY ROUND(SUM(oi.total_sale)::NUMERIC,2)DESC) AS RANK
	
FROM
	orders o
LEFT JOIN order_items oi on o.order_id = oi.order_id
LEFT JOIN customers c on c.customer_id = o.customer_id
GROUP BY
	1,
	2
ORDER BY
	4

--q8
--Inventory Stock Alert for Low Stock Products
--Query Products with stock levels below a certain 
--threshold(e., less than 10 units) 
--Challenge: Include last restock date and warehouse information
	
SELECT 
	 i.product_id,
	 p.product_name,
	 i.stock,
	 i.warehouse_id,
	 last_stock_date

FROM
	inventory AS i
JOIN 
	products AS p ON p.product_id = i.product_id
WHERE
	stock < 10:


--q9 Identify Orders with Shipping Delays
--Identify orders where the shipping date is later than 4 days 
--after the order date.
--Challenge: Include customer, Order details, and delivery provider.

SELECT * FROM orders_items
select * from shippings


SELECT 
	concat(first_name,' ', last_name) as customer_name,
	s.shipping_date - o.order_date as Days_took_to_ship,
	s.shipping_providers
	
FROM
	orders o
LEFT JOIN shippings s ON o.order_id= s.order_id
LEFT JOIN customers c on o.customer_id = c.customer_id
WHERE 
	(s.shipping_date - o.order_date) > 4
GROUP BY
	1,
	2,
	3


--q10 Payment Success Rate Analysis
--Calculate the Percentage of successful payments, 
--access all orders. 
--Challenge: Include breakdown by Payment status (eg., Failed,pending)

SELECT 
	p.payment_status,
	COUNT(p.payment_id),
	ROUND(CAST(COUNT(p.payment_id) AS NUMERIC) /
	(SELECT COUNT(payment_id) FROM payments) * 100,2) AS 
	Percent_breakdown	
FROM
	orders o
LEFT JOIN payments p on o.order_id = p.order_id

GROUP BY
	1

--q11 
--Top Performing Sellers Based on Sales,
--Find the Top 5 sellers based on total Sales value. 
--Challenge: Include both successful and failed Orders, and Display their percentage of successful Orders


--Here I have solved Solved this question in three phases, and In each phase of Query I have
--given insights at different level, so that Stakeholders can Get Insight at different 
--Granularity

--- Top 5 sellers whith the highest sales--
SELECT
	s.seller_id,
	s.seller_name,
	ROUND(SUM(oi.total_sale)::NUMERIC,2) AS total_sale
FROM
	orders o
JOIN
	sellers s on o.seller_id = s.seller_id
JOIN 
	order_items oi on oi.order_id = o.order_id
GROUP BY
	1,
	2
ORDER BY
	3 DESC
LIMIT 
	5
-------------------------------------------------------------	

--- -- Top 5 Best Sellers by Total Sales and Percentage Order Distribution based On Order_Status----

WITH Top_Sellers 
AS
(
	SELECT 
		s.seller_id, 
		s.seller_name, 
		ROUND(SUM(oi.total_sale)::NUMERIC,2) Total_Sales
	FROM Orders o
	JOIN Order_items oi
		ON oi.order_id = o.order_id
	JOIN Sellers s
		ON s.seller_id = o.seller_id
	GROUP BY 
			1,
			2
	ORDER BY 
		3
	LIMIT
		5
), 
Seller_Orders_Statuses
AS (
	SELECT 
	seller_id, 
	order_status, 
	CAST(COUNT(*) as FLOAT) Nr_Orders_By_Seller 
FROM Orders 
GROUP BY
	1,
	2
),
Total_Orders
AS
(SELECT 
	Seller_id, 
	COUNT(order_status) Total_Orders_by_Each_Seller 
FROM 
	Orders
GROUP BY
	1
)

SELECT 
	ts.seller_id,
	ts.seller_name,
	ts.Total_Sales,
	sos.order_status,
	Nr_Orders_By_Seller,
	ROUND((Nr_Orders_By_Seller/Total_Orders_by_Each_Seller)::NUMERIC * 100, 2)  AS Percent_of_Orders
FROM Top_Sellers ts
LEFT JOIN Seller_Orders_Statuses sos
	ON sos.seller_id = ts.seller_id
LEFT JOIN Total_Orders ot
ON ot.seller_id = ts.seller_id
ORDER BY 
		3 DESC

--q12 Product Profit Margin Calculation
--Calculate the profit margin for each product (difference between price and cost of goods sold) 
--Challenge: Rank products by their profit margin, showing highest to lowest

WITH profi_margin AS
(
SELECT 
	p.product_id,
	p.product_name,
	ROUND(sum(oi.total_sale::NUMERIC - (p.cogs * oi.quantity)::NUMERIC), 2) AS profit,
	ROUND(sum(oi.total_sale)::NUMERIC,2) AS total_sale
	
FROM
	products p
JOIN order_items oi on oi.product_id = p.product_id

GROUP BY
	1,
	2
)
SELECT 
product_id,
product_name,
profit,
ROUND((profit/total_sale)::NUMERIC,4) * 100 Profit_Margin_Percentage ,
DENSE_RANK() OVER(ORDER BY profit DESC) Rank_by_Margin
FROM profi_margin;

--q13 
--Most Returned Products and Return Rate
--Query the top 10 products by the number of return. 
--Challenge: Display the return rate as a percentage of total unitssold for each produc_items


WITH  return_rate AS
(SELECT 
	p.product_id,
	p.product_name,
	SUM(oi.quantity) as total_unit_sold,
	SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END ) 
	AS nr_units_returned
	
FROM order_items oi
JOIN products p on oi.product_id = p.product_id
JOIN orders o on o.order_id = oi.order_id

GROUP BY 
	1,
	2
order by
	3 DESC
)
SELECT *,
	ROUND(nr_units_returned::NUMERIC / total_unit_sold::NUMERIC * 100 , 2) as return_rate

FROM  
	return_rate
ORDER BY
	5 DESC


--q14  Inactive Sellers in the Last 6 Months
--Identify Seller who haven't made any sales in the Last 6 months 
--Challenge : Show the last sale date and total sales from those sellers

SELECT MAX(order_date) Last_Order_Date FROM orders
-- Since this dataset is 1 year old as I am doing this project at Jan 2025

-- So I will consider '2024-08-01' as My Today's date
SELECT DATEADD(MONTH,-6, '2024-08-01') Date_before_6_Months; 


-- order_date before 6 months that is '2024-02-01' 
WITH seller_sale
AS
(
	SELECT 
		seller_id,
		seller_name,
		origin
	FROM sellers
	WHERE seller_id  NOT IN
	(
	SELECT DISTINCT seller_id FROM orders
	WHERE order_date >=(SELECT '2024-08-01'::date - INTERVAL '6 months'))
),
Seller_cte2
AS
(
	SELECT
		s.seller_id, 
		MAX(order_date) Last_date_Sale,
		SUM(oi.total_sale) Total_Sales 
	FROM orders o
	JOIN sellers s
		ON o.seller_id = s.seller_id
	JOIN Order_items oi
		ON oi.order_id = o.order_id
	WHERE 
		o.seller_id IN (SELECT seller_id FROM seller_sale) 
	GROUP BY s.seller_id
)
SELECT 
	sc1.seller_id,
	sc1.seller_name,
	sc1.origin,
	sc2.Last_date_Sale,
	COALESCE(sc2.Total_Sales,0) Total_Sales
FROM seller_sale sc1
LEFT JOIN Seller_cte2 sc2
	ON sc1.seller_id =sc2.seller_id


-- q15 Classify Customers as Returning or New Based on Returns
--if the customer has done more than 5 return categorize them as returning otherwise new 
--challenge: List customers id, name, total orders, total returns

WITH customer_category AS
(SELECT 
 	c.customer_id as customer_id,
	concat(c.first_name,' ',c.last_name) as customer_name,
	COUNT(o.order_id) as total_orders,
	COALESCE(SUM(CASE WHEN o.order_status = 'Returned' THEN 1 ELSE 0 END),0) as nr_of_returns 
	
FROM 
	orders o 
JOIN customers c on o.customer_id = c.customer_id
JOIN shippings s ON s.order_id =  o.order_id

GROUP BY
	1,
	2
)
SELECT 
	customer_id, 
	customer_name,
	total_orders,
	CASE WHEN nr_of_returns >= 5 THEN 'Returning_Customers' ELSE 'NEW_CUSTOMER' END AS customer_category
FROM 
	customer_category
	

--Q16 Top 5 Customers by Orders in Each State
--Identify the Top 5 Customers with the Highest number of Orders for Each State. 
--Challenge: Include the Number of Orders and total Sales for each Customer.

SELECT * FROM

(SELECT
	c.state,
	c.customer_id,
	concat(c.first_name,' ',c.last_name) AS customer_name,
	COUNT(o.order_id) AS total_orders,
	ROUND(SUM(oi.total_sale)::NUMERIC,2) as total_sale,
	RANK() OVER(PARTITION BY c.state  ORDER BY COUNT(o.order_id) DESC) Rank_by_Orders
FROM 
	orders o
JOIN customers c
ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id

GROUP BY
	1,
	2,
	3
) t1

WHERE Rank_by_Orders <= 5
ORDER BY
 1

/*17 Revenue by Shipping Provider Analysis
Calculate the Total Revenue handled by each shipping provider. 
Challenge: Include the Total Number of Orders handled and the Average delivery time for each provider */

SELECT 
    sh.shipping_providers, 
    ROUND(SUM(oi.total_sale)::NUMERIC, 2) AS Total_Sales, 
    COUNT(o.order_id) AS Nr_of_Orders,
    ROUND(AVG((sh.shipping_date - o.order_date) * 1.0), 2) AS AVG_Time_taken_to_Deliver_in_days
FROM 
    Orders o
JOIN 
    shippings sh ON sh.order_id = o.order_id
JOIN 
    Order_items oi ON oi.order_id = o.order_id
GROUP BY 
    sh.shipping_providers;


/*q18 10 Product with Highest decreasing revenue ratio compare to last year(2022) and current year(2023), 
Return product_id, Product_name, category_name,2022 revenue and 2023 Revenue decrease ratio at end Round the result */

WITH total_revenue_2022 AS

(SELECT
	p.product_id,
	p.product_name,
	c.category_name,
	ROUND(SUM(oi.total_sale)::NUMERIC,2) as revenue	
FROM 
    orders o
JOIN 
    order_items oi ON oi.order_id = o.order_id
JOIN 
    products p ON p.product_id= oi.product_id
JOIN 
	category c ON c.category_id = p.category_id
WHERE EXTRACT(year from o.order_date) = 2022
GROUP BY 
	1,
	2,
	3
),

total_revenue_2023 AS
(
SELECT
	p.product_id,
	p.product_name,
	c.category_name,
	ROUND(SUM(oi.total_sale)::NUMERIC,2) as revenue
FROM 
    orders o
JOIN 
    order_items oi ON oi.order_id = o.order_id
JOIN 
    products p ON p.product_id = oi.product_id
JOIN 
	category c ON c.category_id = p.category_id
WHERE EXTRACT(year from o.order_date) = 2023
GROUP BY 
	1,
	2,
	3
	
)
SELECT
	cs.product_id as product_id,
	cs.product_name as product_name,
	ls.revenue as last_year_revenue_2022,
	cs.revenue as current_year_revenue_2023,
	(ls.revenue - cs.revenue) as revenue_difference,
	--ROUND(CASE WHEN ls.revenue > 0 THEN (ls.revenue - cs.revenue)::NUMERIC
	--		/ ls.revenue::NUMERIC * 100 ELSE NULL END, 2) AS Percent_Change
	ROUND((cs.revenue- ls.revenue)::NUMERIC / ls.revenue::NUMERIC *100 ,2) as revenue_ratio
	
FROM 
	total_revenue_2022 as ls
JOIN 
	total_revenue_2023 as cs

ON
	ls.product_id = cs.product_id
WHERE ls.revenue > cs.revenue

ORDER BY
	6 
LIMIT 10

/*19  Create a function as soon as the product is sold the same quantity should reduced from Inventory table */


Select * from orders
-- max order id 21630 i need take
select max(order_item_id) from order_items
where product_id = 1
select * from inventory
select * from products

p_order_id,
p_customer_id,
p_seller_id,
p_order_item_id,
p_proudct_id
p_quantity,

CREATE OR REPLACE PROCEDURE add_sales
(
	p_order_id INT,
	p_customer_id INT,
	p_seller_id INT,
	p_order_item_id INT,
	p_product_id INT,
	p_quantity INT
)
LANGUAGE  plpgsql
	AS $$
	
DECLARE
	
	---All variables need to bedeclared Here
	
	v_count INT;
	v_price FLOAT;
	v_product VARCHAR(55);
	
	
BEGIN
	--ALl the codeand logic

---Fetching product name and price	
	SELECT price,product_name
		INTO
		v_price, v_product
	FROM products	
	WHERE 
		product_id = p_product_id;
---Checking stock and product availablity in inventory
	
	SELECT COUNT(*)
		INTO v_count
		FROM 
			inventory
		WHERE product_id = p_product_id
		AND stock >= p_quantity;

		IF v_count > 0 THEN
-- add into the orders and order_items
			--update the inventory
			INSERT INTO orders(order_id,order_date,customer_id,seller_id)
			values(p_order_id,CURRENT_DATE,p_customer_id,p_seller_id);
	
--updating the order_items
			INSERT INTO order_items(order_item_id,order_id,product_id,quantity,price_per_unit,total_sale)
			VALUES(p_order_item_id,p_order_id,p_product_id,p_quantity,v_price, v_price*p_quantity);
	
---update the inventory table
			UPDATE inventory
			SET stock = stock - p_quantity
			WHERE product_id = p_product_id;
	
			RAISE NOTICE 'Thank you product: % sale has been added also inventory stocck updated',v_product;

		ELSE
			RAISE NOTICE 'Thank you for your  info the product:% is not available ',v_product;
		
		END IF;
END
$$

CALL add_sales
(
21633,2,5,21633,2,40
)

select * from inventory
where product_id =2

/* q20 : Least Selling Category by State 
Identify the least-selling product for each state
Challenge: Include the Total Sales for that category within each State.
*/

WITH sales_category AS
(
SELECT 
	c.state AS State,
	ct.category_name AS Category,
	ROUND(SUM(oi.total_sale)::NUMERIC,2) as total_sale,
	RANK() OVER( PARTITION BY c.state ORDER BY SUM(oi.total_Sale) ASC) RANK
FROM 
	orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN category ct ON ct.category_id = p.category_id

GROUP BY
	1,
	2
)
SELECT 
	State,
	Category,
	total_sale,
	RANK
FROM sales_category
WHERE
	RANK = 1
ORDER BY
	1,
	3
	






