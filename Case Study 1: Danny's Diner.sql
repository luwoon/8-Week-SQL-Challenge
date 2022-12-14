-- 1. What is the total amount each customer spent at the restaurant?

select customer_id
,sum(price) as total_amount_spent
from dannys_diner.sales 
join dannys_diner.menu using(product_id)
group by customer_id
order by customer_id;

-- 2. How many days has each customer visited the restaurant?

select customer_id
,count(distinct order_date) as n_days_visited
from dannys_diner.sales
group by customer_id
order by customer_id;

-- 3. What was the first item from the menu purchased by each customer?

with first_item_cte as (
select *
,rank() over(partition by customer_id order by order_date) as item_n
from dannys_diner.sales
)
select customer_id
,order_date
,product_name as first_item_purchased
from first_item_cte
join dannys_diner.menu using(product_id)
where item_n = 1
order by customer_id;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

select product_name
,count(product_id) as times_purchased
from dannys_diner.sales
join dannys_diner.menu using(product_id)
group by product_name
order by times_purchased desc
limit 1;

-- 5. Which item was the most popular for each customer?

with most_popular_cte as (
select customer_id
,product_id
,rank() over(partition by customer_id order by count(product_id) desc)
from dannys_diner.sales
group by customer_id
,product_id
)
select customer_id
,product_name
from most_popular_cte
join dannys_diner.menu using(product_id)
where rank=1
order by customer_id;

-- 6. Which item was purchased first by the customer after they became a member?

with after_member_cte as (
select *
,row_number() over(partition by customer_id order by order_date) as purchased
from dannys_diner.sales
join dannys_diner.members using(customer_id)
where order_date > join_date
)
select customer_id
,product_name
from after_member_cte
join dannys_diner.menu using(product_id)
where purchased = 1
order by customer_id;

-- 7. Which item was purchased just before the customer became a member?

with before_member_cte as (
select *
,rank() over(partition by customer_id order by order_date desc) as purchased
from dannys_diner.sales
join dannys_diner.members using(customer_id)
where order_date < join_date
)
select customer_id
,product_name
from before_member_cte
join dannys_diner.menu using(product_id)
where purchased = 1
order by customer_id;

-- 8. What is the total items and amount spent for each member before they became a member?

select customer_id
,count(product_id) as total_items
,sum(price) as amount_spent
from dannys_diner.sales
join dannys_diner.menu using(product_id)
join dannys_diner.members using(customer_id)
where order_date < join_date
group by customer_id;

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with points_cte as (
select customer_id
,product_id
,price
,case product_id
when 1 then 20*price
when 2 then 10*price
when 3 then 10*price
end as points
from dannys_diner.sales 
join dannys_diner.menu  using(product_id)
)
select customer_id
,sum(points) as points
from points_cte
group by customer_id
order by customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

with first_week_cte as (
select customer_id
,order_date
,product_id
,price
,case
when product_id=1 then 20*price
when product_id=2 and order_date between join_date and join_date + 7 then 20*price
when product_id=3 and order_date between join_date and join_date + 7 then 20*price
else 10*price
end as points
from dannys_diner.sales 
join dannys_diner.menu using(product_id)
join dannys_diner.members using(customer_id)
)
select customer_id
,sum(points) as points
from first_week_cte
where customer_id in (select customer_id from dannys_diner.members)
group by customer_id
order by customer_id;
