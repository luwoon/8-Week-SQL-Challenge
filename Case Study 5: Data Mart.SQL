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
