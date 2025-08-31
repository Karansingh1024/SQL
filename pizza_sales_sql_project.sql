create database pizza;

CREATE TABLE orders (
    order_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    PRIMARY KEY (order_id)
);

CREATE TABLE orders_details (
    order_details_id INT NOT NULL,
    order_id INT NOT NULL,
    pizza_id TEXT NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (order_details_id)
);

-- 1 Retrieve the total number of orders placed.
create view Total_order_placed as
SELECT COUNT(order_id) AS total_orders
FROM orders;

 select * from Total_order_placed;
 
-- 2 Calculate the total revenue generated from pizza sales.
create view Total_revenue as
SELECT ROUND(SUM(orders_details.quantity * pizzas.price),
2) AS total_sales
FROM orders_details
JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id;
    
select * from Total_revenue;

-- 3 Identify the highest-priced pizza.
create view Highest_priced_pizza as
SELECT pizza_types.name, pizzas.price
FROM pizza_types
JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 1;

select * from Highest_priced_pizza;

-- 4 Identify the most common pizza size ordered.
select quantity, count(order_details_id)
from orders_details group by quantity;
create view Most_ordered_pizza_size as
SELECT 
pizzas.size,COUNT(orders_details.order_details_id) AS order_count
FROM pizzas
JOIN orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;

select * from Most_ordered_pizza_size;

-- 5 List the top 5 most ordered pizza types along with their quantities.
create view Top_5_Pizzas_type as
SELECT pizza_types.name,
SUM(orders_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC LIMIT 5;

select * from Top_5_pizzas_type;
create view Top_5_Pizzas_type as
SELECT pizza_types.name,
SUM(orders_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC LIMIT 5;

select * from Top_5_pizzas_type;

-- 6 Join the necessary tables to find the total quantity of each pizza category ordered.
create view pizza_category_ordered as
SELECT pizza_types.category,
SUM(orders_details.quantity) AS quantity
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

select * from Pizza_category_ordered;

-- 7 Determine the distribution of orders by hour of the day.
create view distribution_of_orders as
SELECT HOUR(order_time), COUNT(order_id) AS order_count
FROM orders
GROUP BY HOUR(order_time);

select * from distribution_of_orders;

-- 8 Join relevant tables to find the category-wise distribution of pizzas.
create view category_wise_distribution as
SELECT category, COUNT(name)
FROM pizza_types
GROUP BY category;

select * from category_wise_distribution;

-- 9 Group the orders by date and calculate the average number of pizzas ordered per day.
create view Avg_order_per_day as
SELECT ROUND(AVG(quantity), 0)
FROM (SELECT 
orders.order_date, SUM(orders_details.quantity) AS quantity
FROM orders
JOIN orders_details ON orders.order_id = orders_details.order_id
GROUP BY orders.order_date) AS order_quantity;

select * from Avg_order_per_day;

-- 10 Determine the top 3 most ordered pizza types based on revenue.
create view top_3_pizza_by_revenue as
SELECT pizza_types.name,
SUM(orders_details.quantity * pizzas.price) AS revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC LIMIT 3;

select * from top_3_pizza_by_revenue;

-- 11 Calculate the percentage contribution of each pizza type to total revenue.
create view pizza_type_total_revenue as
SELECT pizza_types.category,
ROUND((SUM(orders_details.quantity * pizzas.price) / (SELECT 
ROUND(SUM(orders_details.quantity * pizzas.price),
2) AS total_sales
FROM orders_details
JOIN pizzas ON pizzas.pizza_id = orders_details.pizza_id)) * 100,
2) AS revenue
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

select * from pizza_type_total_revenue;

-- 12 Analyze the cumulative revenue generated over time.
create view cumulative_revenue_over_time as
select order_date,
round(sum(revenue) over(order by order_date),0) as cum_revenue
from 
(select orders.order_date,
sum(orders_details.quantity * pizzas.price) as revenue
from orders_details join pizzas
on orders_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = orders_details.order_id
group by orders.order_date) as sales;

select * from cumulative_revenue_over_time;

-- 13 pizza types based on revenue for each pizza category.
create view Pizza_types_and_revenue as
select name, revenue from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(SELECT 
    pizza_types.category,
    pizza_types.name,
    round(SUM((orders_details.quantity) * pizzas.price),0) AS revenue
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name) as a) as b
where rn <= 3;

select * from Pizza_types_and_revenue;

-- 1 Retrieve the total number of orders placed.
select * from Total_order_placed;

-- 2 Calculate the total revenue generated from pizza sales.
select * from Total_revenue;

-- 3 Identify the highest-priced pizza.
select * from Highest_priced_pizza;

-- 4 Identify the most common pizza size ordered.
select * from Most_ordered_pizza_size;

-- 5 List the top 5 most ordered pizza types along with their quantities.
select * from Top_5_pizzas_type;

-- 6 Join the necessary tables to find the total quantity of each pizza category ordered.
select * from Pizza_category_ordered;

-- 7 Determine the distribution of orders by hour of the day.
select * from distribution_of_orders;

-- 8 Join relevant tables to find the category-wise distribution of pizzas.
select * from category_wise_distribution;

-- 9 Group the orders by date and calculate the average number of pizzas ordered per day.
select * from Avg_order_per_day;

-- 10 Determine the top 3 most ordered pizza types based on revenue.
select * from top_3_pizza_by_revenue;

-- 11 Calculate the percentage contribution of each pizza type to total revenue.
select * from pizza_type_total_revenue;

-- 12 Analyze the cumulative revenue generated over time.
select * from cumulative_revenue_over_time;

-- pizza types based on revenue for each pizza category.
select * from Pizza_types_and_revenue;


