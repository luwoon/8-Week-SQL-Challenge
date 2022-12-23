--Data Cleaning

select to_date(week_date, 'DD/MM/YY') as week_date
,date_part('week', to_date(week_date, 'DD/MM/YY')) as week_number
,date_part('month', to_date(week_date, 'DD/MM/YY')) as month_number
,date_part('year', to_date(week_date, 'DD/MM/YY')) as year
,region
,platform
,case
when segment='null' then 'unknown'
else segment
end as segment
,case
when segment like '_1' then 'Young Adults'
when segment like '_2' then 'Middle Aged'
when segment like '_3' or segment like '_4' then 'Retirees'
else 'unknown'
end as age_band
,case 
when segment like 'C_' then 'Couples'
when segment like 'F_' then 'Families'
else 'unknown'
end as demographic
,customer_type
,transactions
,sales
,round(sales/transactions,2) as avg_transactions
into data_mart.clean_weekly_sales
from data_mart.weekly_sales;
select * from data_mart.clean_weekly_sales;


--Data Exploration

--1. What day of the week is used for each week_date value?

select extract(dow from week_date) as day_of_week
from data_mart.clean_weekly_sales; --Monday

--2. What range of week numbers are missing from the dataset?

select distinct(week_number)
from data_mart.clean_weekly_sales; --1 to 12 and 37 to 52

--3. How many total transactions were there for each year in the dataset?

select year
,count(transactions) as total_transactions
from data_mart.clean_weekly_sales
group by year;

--4. What is the total sales for each region for each month?

select month_number
,year
,region
,sum(sales) as total_sales
from data_mart.clean_weekly_sales
group by region
,month_number
,year;

--5. What is the total count of transactions for each platform?

select platform
,count(transactions) as total_transactions_count
from data_mart.clean_weekly_sales
group by platform;

--6. What is the percentage of sales for Retail vs Shopify for each month?
--7. What is the percentage of sales by demographic for each year in the dataset?
--8. Which age_band and demographic values contribute the most to Retail sales?
--9. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? If not - how would you calculate it instead?
