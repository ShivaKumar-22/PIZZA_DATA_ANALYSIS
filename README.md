# PIZZA_DATA_ANALYSIS

1. Database & Table Understanding
Used database: pizza_project

Tables involved:

orders: order_id, date, time

order_details: order_id, pizza_id, quantity

pizzas: pizza_id, pizza_type_id, size, price

pizza_types: pizza_type_id, name, category, ingredients

2. Data Import & Exploration
Used SELECT * to explore each table and understand relationships.

Key relationships:

orders ⇄ order_details (via order_id)

order_details ⇄ pizzas (via pizza_id)

pizzas ⇄ pizza_types (via pizza_type_id)

3. Business Questions & SQL Analysis
✅ Business Question	🧮 Query Performed

Total number of orders placed	               COUNT(DISTINCT order_id),

Total revenue generated	                     SUM(quantity * price), 

Highest-priced pizza	                       TOP 1 ORDER BY price DESC,
 
Most common pizza size ordered	             GROUP BY size, 

Top 5 most ordered pizza types	             TOP 5 ORDER BY quantity DESC, 

Total quantity by pizza category	           GROUP BY category, 

Orders by hour of day	                       DATEPART(hour, time), 

No. of pizzas per category	                 GROUP BY category, 

Average pizzas ordered per day	             AVG(count per day), 

Top 3 revenue-generating pizzas	             TOP 3 ORDER BY revenue DESC, 

Revenue contribution by category and by pizza	  % contribution with subquery, 

Cumulative revenue over time	                  SUM() OVER (ORDER BY date), 

Top 3 pizzas per category based on revenue	    RANK() OVER (PARTITION BY category), 

⭐ Key Points from Data
Total Orders: Number of distinct orders in the dataset.

Total Revenue: Revenue from all pizzas sold.

Highest-Priced Pizza: Pizza with the highest unit price.

Most Common Size: Size ordered the most.

Top Selling Pizzas: Based on quantity and revenue.

Pizza Category Distribution: Which categories are most/least ordered.

Peak Order Time: Hour of the day when most orders happen.

Average Daily Orders: Insights into customer demand.

Revenue % per Category/Pizza: Who contributes the most to profit.

Cumulative Trend: Growth of revenue over time.

Top Performers by Category: Best pizzas within each category.

📊 Key Insights
Revenue Generated:

High-value pizzas (like large/gourmet options) drive significant revenue.

Top 3 pizzas contribute a major portion of total revenue.

Order Behavior:

Peak ordering happens during evening hours.

Medium and large sizes are most popular among customers.

Customer Preferences:

Certain pizza categories (e.g., Classic or Veggie) are ordered more frequently.

Specific pizza types dominate both quantity and revenue (brand loyalty or taste preference).

Business Recommendations:

Focus marketing on best-selling and high-margin pizzas.

Prepare for peak hours (demand planning).

Consider offering combo deals with top 3 pizzas.

Analyze slow-moving pizza categories for possible discontinuation or improvement.

