# Amazon Sales SQL Project: Advanced E-commerce Analytics with SQL

Welcome to the GitHub repository for the **Amazon Sales SQL Project**. This project highlights advanced data analysis and business intelligence using **PostgreSQL** across various domains like customer segmentation, inventory alerts, product returns, seller performance, and more.

---

<div align="center">
  <img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Amazon_img.jpg" width="1400" alt="Amazon Ecosystem ERD Diagram">
  <p><em>Amazon Ecosystem: Entity-Relationship Diagram</em></p>
</div>

## Project Overview

This project demonstrates data manipulation and business problem-solving through structured SQL queries. Using a simulated e-commerce dataset for an Amazon-like platform, this analysis uncovers:
- Revenue trends
- Seller effectiveness
- Product profitability
- Inventory control
- Customer behaviors

---

## Database Schema Overview

### Tables Used:

**category**
- `category_id`, `category_name`

**customers**
- `customer_id`, `first_name`, `last_name`, `state`, `registration_date`

**products**
- `product_id`, `product_name`, `category_id`, `price`, `cogs`

**orders**
- `order_id`, `order_date`, `customer_id`, `seller_id`, `order_status`

**order_items**
- `order_item_id`, `order_id`, `product_id`, `quantity`, `price_per_unit`, `total_sale`

**payments**
- `payment_id`, `order_id`, `payment_status`

**sellers**
- `seller_id`, `seller_name`, `origin`

**shippings**
- `shipping_id`, `order_id`, `shipping_providers`, `shipping_date`, `return_date`

**inventory**
- `inventory_id`, `product_id`, `warehouse_id`, `stock`, `last_stock_date`

---

## Entity-Relationship Diagram (ERD)
<img width="646" alt="image" src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/ERD.png">

---

## Key Business Questions and SQL Solutions

Each question below contains a collapsible dropdown with a description and a screenshot output.

### Q1. Top 10 Best-Selling Products by Revenue
<details><summary><strong>Description</strong></summary>
Identify top-selling products by total sales value.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/q1output.png" height="200">
</details>

### Q2. Revenue Breakdown by Product Category
<details><summary><strong>Description</strong></summary>
Calculate category-wise revenue and its percentage contribution.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q2.png" height="200">
</details>

### Q3. Average Order Value (AOV) for Active Customers
<details><summary><strong>Description</strong></summary>
Find customers with more than 5 orders and compute AOV.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q3.png" height="200">
</details>

### Q4. Monthly Sales Trend
<details><summary><strong>Description</strong></summary>
Track monthly sales and compare with previous month.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q4.png" height="200">
</details>

### Q5. Customers Registered but Never Purchased
<details><summary><strong>Description</strong></summary>
List customers who never placed an order.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q5.png" height="200">
</details>

### Q6. Best Selling Category by State
<details><summary><strong>Description</strong></summary>
Identify top-performing categories in each state.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q6.png" height="200">
</details>

### Q7. Customer Lifetime Value (CLV) Ranking
<details><summary><strong>Description</strong></summary>
Rank customers based on total sales contribution.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q7.png" height="200">
</details>

### Q8. Low Inventory Alert
<details><summary><strong>Description</strong></summary>
Identify products with less than 10 units in stock.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q8.png" height="200">
</details>

### Q9. Orders with Shipping Delays
<details><summary><strong>Description</strong></summary>
Highlight orders shipped more than 4 days after ordering.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q9.png" height="200">
</details>

### Q10. Payment Success Rate
<details><summary><strong>Description</strong></summary>
Percentage breakdown of different payment statuses.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q10.png" height="200">
</details>

### Q11. Top Sellers Performance Analysis
<details><summary><strong>Description</strong></summary>
Top 5 sellers by revenue and their success rate.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q11.png" height="200">
</details>

### Q12. Product Profit Margin
<details><summary><strong>Description</strong></summary>
Calculate and rank products based on profit margins.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q12.png" height="200">
</details>

### Q13. Most Returned Products and Return Rate
<details><summary><strong>Description</strong></summary>
Identify products with highest return rates.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q13.png" height="200">
</details>

### Q14. Inactive Sellers in the Last 6 Months
<details><summary><strong>Description</strong></summary>
Sellers with no sales in past 6 months and their last sale date.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q14.png" height="200">
</details>

### Q15. New vs Returning Customers Based on Returns
<details><summary><strong>Description</strong></summary>
Classify customers as new or returning based on return count.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q15.png" height="200">
</details>

### Q16. Top 5 Customers by State
<details><summary><strong>Description</strong></summary>
Top customers by order volume and revenue per state.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q16.png" height="200">
</details>

### Q17. Shipping Provider Revenue Contribution
<details><summary><strong>Description</strong></summary>
Total sales and average delivery time per shipping provider.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q17.png" height="200">
</details>

### Q18. Products with Highest Revenue Drop YoY
<details><summary><strong>Description</strong></summary>
Compare revenue drop from 2022 to 2023.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q18.png" height="200">
</details>

### Q19. Inventory Update via Function
<details><summary><strong>Description</strong></summary>
SQL procedure to deduct sold quantity from inventory in real-time.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q19.png" height="200">
</details>

### Q20. Least Selling Category by State
<details><summary><strong>Description</strong></summary>
List categories with lowest sales per state.
<br><strong>Query Output:</strong><br><img src="https://github.com/prashanthkumarjoshi/Amazon-Ecosystem/blob/main/Images/Q20.png" height="200">
</details>

---

## Project Focus Areas

- **Advanced Joins & CTEs**
- **Window Functions & Ranking**
- **Dynamic Business Metrics**
- **Inventory Management**
- **Profitability & Return Rate Analysis**
- **Stored Procedures for Real-Time Operations**



## Author
**Prashanth Kumar Joshi**  
Data Analyst | Cloud Enthusiast | SQL Expert

---

## License
Open source for learning purposes.

