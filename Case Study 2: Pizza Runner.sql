--A. Pizza Metrics

--1. How many pizzas were ordered?

select count(*) as n_pizzas_ordered
from pizza_runner.customer_orders;

--2. How many unique customer orders were made?

select count(distinct order_id) as unique_customer_orders
from pizza_runner.customer_orders;

--3. How many successful orders were delivered by each runner?

select runner_id
,count(order_id) as n_successful_orders
from pizza_runner.runner_orders
where cancellation is null or cancellation not in ('Restaurant Cancellation', 'Customer Cancellation')
group by runner_id
order by runner_id;

--4. How many of each type of pizza was delivered?

select pizza_name
,count(pizza_id) as n_delivered
from pizza_runner.customer_orders
left join pizza_runner.pizza_names using(pizza_id)
where order_id in (
select order_id
from pizza_runner.runner_orders
where cancellation is null or cancellation not in ('Restaurant Cancellation', 'Customer Cancellation')
)
group by pizza_name;

--5. How many Vegetarian and Meatlovers were ordered by each customer?

with pizza_id_cte as (
select customer_id
,case
when pizza_id=1 then 1
end as pizza_1
,case when pizza_id=2 then 1
end as pizza_2
from pizza_runner.customer_orders
)
select customer_id
,count(pizza_1) as meatlovers_count
,count(pizza_2) as vegetarian_count
from pizza_id_cte
group by customer_id;

--6. What was the maximum number of pizzas delivered in a single order?

with max_number_cte as (
select order_id
,count(pizza_id) as pizza_count
from pizza_runner.customer_orders
group by order_id
)
select max(pizza_count) as max_n
from max_number_cte
where order_id in (
select order_id
from pizza_runner.runner_orders
where cancellation is null or cancellation not in ('Restaurant Cancellation', 'Customer Cancellation')
);

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select *
,case when exclusions='' or exclusions='null' or exclusions is null then 0 else 1 end as count_exclusions
,case when extras='' or extras='null' or extras is null then 0 else 1  end as count_extras
from pizza_runner.customer_orders;




--8. How many pizzas were delivered that had both exclusions and extras?

with exclusions_extras_count as (
select *
,case 
when exclusions is null then 0
when exclusions='null' then 0
when exclusions='NaN' then 0
when exclusions='' then 0
else 1
end as exclusions_count
,case
when extras is null then 0
when extras='null' then 0
when extras='NaN' then 0
when extras='' then 0
else 1
end as extras_count
from pizza_runner.customer_orders
left join pizza_runner.runner_orders using(order_id)
where cancellation is null or cancellation not in ('Restaurant Cancellation', 'Customer Cancellation')
)
select count(pizza_id)
from exclusions_extras_count
where exclusions_count=1 and extras_count=1;

--9. What was the total volume of pizzas ordered for each hour of the day?
--10. What was the volume of orders for each day of the week?

--B. Runner and Customer Experience
--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
--4. What was the average distance travelled for each customer?
--5. What was the difference between the longest and shortest delivery times for all orders?
--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
--7. What is the successful delivery percentage for each runner?
