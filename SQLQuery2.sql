
/*
sql case study project 
*/

use pizza_project

-- Let's Import the csv files
-- Now Understand each (all columns)

select * from order_details;   --order_detailss_id     order_id  pizza_id  quantity

select * from pizzas  --pizza_id,  pizza_type_id, size, price

select * from orders  --order_id, date, time

select * from pizza_types   --pizza_type_id, name, category, ingrediants


--questions :

--Retrieve the total number of orders placed.
select count(distinct order_id) as 'Total Orders' from orders; 

--Calculate the total revenue generated from pizza sales.

--to see the details 
select order_details.pizza_id, order_details.quantity, pizzas.price
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id

-- to get the answer 
select cast(sum(order_details.quantity * pizzas.price) as decimal(10, 2)) as 'Total Revenue'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id

--Identify the highest-priced pizza.
--using Top function
select top 1 pizza_types.name as 'Pizza Name', cast(pizzas.price as decimal(10, 2)) as 'Price'
from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc

--Alternative using (using window function) - without using top function
;
with cte as (
select pizza_types.name as 'Pizza Name', cast(pizzas.price as decimal(10, 2)) as 'Price',
rank() over (order by price desc) as rnk
from pizzas
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
)
select [Pizza Name], price from cte where rnk = 1

--Identify the most common pizza size ordered.

select pizzas.size, count(distinct order_id) as 'No of Orders',  count(quantity) as  'Total Quantity Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
-- join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizzas.size
order by count(distinct order_id) desc

--List the top 5 most ordered pizza types along with their quantities.

select top 5 pizza_types.name as 'Pizza', count(quantity) as ' Total Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name 
order by count(quantity) desc

--Join the necessary tables to find the total quantity of each pizza category ordered.

select top 5 pizza_types.category, count(quantity) as 'Total Quantity Ordered'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category
order by count(quantity) desc

--Determine the distribution of orders by hour of the day

select datepart(hour, time) as 'Hour of the day', count(distinct order_id) as 'No of Orders'
from orders
group by datepart(hour, time)
order by [No of Orders] desc

--Find the category wise distribution of pizzas

select category, count(distinct pizza_type_id) as [No of pizzas]
from pizza_types
group by category
order by [No of pizzas]

--calculate the average number of pizzas ordered per day.

with cte as (
select orders.date as 'Date', count(order_details.quantity) as 'Total Pizza Ordered that day'
from order_details
join orders on order_details.order_id = orders.order_id
group by orders.date
)
select avg([Total Pizza Ordered that day]) as [Avg Number of pizzas ordered per day] from cte

--alternating sub query

select avg([Total Pizza Ordered that day]) as [Avg Number of pizzas ordered per day] from 
(
select orders.date as 'Date', count(order_details.quantity) as 'Total Pizza Ordered that day'
from order_details
join orders on order_details.order_id = orders.order_id
group by orders.date
) as pizzas_ordered

--Determine the top 3 most ordered based on revenue.

select top 3 pizza_types.name, sum(order_details.quantity*pizzas.price) as 'Revenue from pizza'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by [revenue from pizza] desc

--Calculate the percentage contribution of each pizza type to total revenue 

select pizza_types.category,
concat(cast((sum(order_details.quantity*pizzas.price) /
(select sum(order_details.quantity*pizzas.price)
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
))*100 as decimal(10,2)), '%')
as 'Revenue contribution from pizza'
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category

--Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category,
concat(cast((sum(order_details.quantity*pizzas.price)

/
--to get the total revenue (use below subquery)
(select sum(order_details.quantity*pizzas.price)
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id

)) *100 as decimal(10,2)), '%') as 'Revenue contribution from pizza'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category

--revenue contribution from each pizza by pizza name

select pizza_types.name,
concat(cast((sum(order_details.quantity*pizzas.price)/
(select sum(order_details.quantity*pizzas.price)
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
)) *100 as decimal(10,2)), '%') as 'Revenue contribution from pizza'
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by [Revenue contribution from pizza] desc

--Analyze the cumulative revenue generated over time.
--use of aaggregate window function (to get the cumulative sum)

with cte as (
select date as 'Date', cast(sum(quantity*price) as decimal(10, 2)) as Revenue
from order_details 
join orders on order_details.order_id = orders.order_id
join pizzas on pizzas.pizza_id = order_details.pizza_id
group by date
--order by [revenue] desc
)

select Date, Revenue, sum(Revenue) over (order by  date) as 'Cummulative Sum'
from cte 
group by date, Revenue


--Determine the top 3 most ordered pizza types based on revenue for each pizza category.

with cte as (
select category, name, cast(sum(quantity*price) as decimal(10,2)) as Revenue
from order_details 
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by category, name
-- order by category, name, Revenue desc
)
, cte1 as (
select category, name, Revenue,
rank() over (partition by category order by Revenue desc) as rnk
from cte 
)
select category, name, Revenue
from cte1 
where rnk in (1,2,3)
order by category, name, Revenue