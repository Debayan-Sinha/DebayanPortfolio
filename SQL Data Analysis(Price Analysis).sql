create database steel_5_db;
use steel_5_db;

set sql_safe_updates = 0;
SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

/*Intro
You are a Pricing Analyst working for a pub chain called 'Pubs "R" Us'

You have been tasked with analysing the drinks prices and sales to gain a greater insight into how the pubs in your chain are performing.*/

CREATE TABLE pubs (
pub_id INT PRIMARY KEY,
pub_name VARCHAR(50),
city VARCHAR(50),
state VARCHAR(50),
country VARCHAR(50)
);
--------------------
-- Create the 'beverages' table
CREATE TABLE beverages (
beverage_id INT PRIMARY KEY,
beverage_name VARCHAR(50),
category VARCHAR(50),
alcohol_content FLOAT,
price_per_unit DECIMAL(8, 2)
);
--------------------
-- Create the 'sales' table
CREATE TABLE sales (
sale_id INT PRIMARY KEY,
pub_id INT,
beverage_id INT,
quantity INT,
transaction_date DATE,
FOREIGN KEY (pub_id) REFERENCES pubs(pub_id),
FOREIGN KEY (beverage_id) REFERENCES beverages(beverage_id)
);
--------------------
-- Create the 'ratings' table 
CREATE TABLE ratings 
( rating_id INT PRIMARY KEY, 
pub_id INT, customer_name VARCHAR(50), 
rating FLOAT, 
review TEXT, 
FOREIGN KEY (pub_id) 
REFERENCES pubs(pub_id) );
--------------------
-- Insert sample data into the 'pubs' table
INSERT INTO pubs (pub_id, pub_name, city, state, country)
VALUES
(1, 'The Red Lion', 'London', 'England', 'United Kingdom'),
(2, 'The Dubliner', 'Dublin', 'Dublin', 'Ireland'),
(3, 'The Cheers Bar', 'Boston', 'Massachusetts', 'United States'),
(4, 'La Cerveceria', 'Barcelona', 'Catalonia', 'Spain');
--------------------
-- Insert sample data into the 'beverages' table
INSERT INTO beverages (beverage_id, beverage_name, category, alcohol_content, price_per_unit)
VALUES
(1, 'Guinness', 'Beer', 4.2, 5.99),
(2, 'Jameson', 'Whiskey', 40.0, 29.99),
(3, 'Mojito', 'Cocktail', 12.0, 8.99),
(4, 'Chardonnay', 'Wine', 13.5, 12.99),
(5, 'IPA', 'Beer', 6.8, 4.99),
(6, 'Tequila', 'Spirit', 38.0, 24.99);
--------------------
INSERT INTO sales (sale_id, pub_id, beverage_id, quantity, transaction_date)
VALUES
(1, 1, 1, 10, '2023-05-01'),
(2, 1, 2, 5, '2023-05-01'),
(3, 2, 1, 8, '2023-05-01'),
(4, 3, 3, 12, '2023-05-02'),
(5, 4, 4, 3, '2023-05-02'),
(6, 4, 6, 6, '2023-05-03'),
(7, 2, 3, 6, '2023-05-03'),
(8, 3, 1, 15, '2023-05-03'),
(9, 3, 4, 7, '2023-05-03'),
(10, 4, 1, 10, '2023-05-04'),
(11, 1, 3, 5, '2023-05-06'),
(12, 2, 2, 3, '2023-05-09'),
(13, 2, 5, 9, '2023-05-09'),
(14, 3, 6, 4, '2023-05-09'),
(15, 4, 3, 7, '2023-05-09'),
(16, 4, 4, 2, '2023-05-09'),
(17, 1, 4, 6, '2023-05-11'),
(18, 1, 6, 8, '2023-05-11'),
(19, 2, 1, 12, '2023-05-12'),
(20, 3, 5, 5, '2023-05-13');
-- --------------------
-- Insert sample data into the 'ratings' table
INSERT INTO ratings (rating_id, pub_id, customer_name, rating, review)
VALUES
(1, 1, 'John Smith', 4.5, 'Great pub with a wide selection of beers.'),
(2, 1, 'Emma Johnson', 4.8, 'Excellent service and cozy atmosphere.'),
(3, 2, 'Michael Brown', 4.2, 'Authentic atmosphere and great beers.'),
(4, 3, 'Sophia Davis', 4.6, 'The cocktails were amazing! Will definitely come back.'),
(5, 4, 'Oliver Wilson', 4.9, 'The wine selection here is outstanding.'),
(6, 4, 'Isabella Moore', 4.3, 'Had a great time trying different spirits.'),
(7, 1, 'Sophia Davis', 4.7, 'Loved the pub food! Great ambiance.'),
(8, 2, 'Ethan Johnson', 4.5, 'A good place to hang out with friends.'),
(9, 2, 'Olivia Taylor', 4.1, 'The whiskey tasting experience was fantastic.'),
(10, 3, 'William Miller', 4.4, 'Friendly staff and live music on weekends.');
-- --------------------


#______________________________1. How many pubs are located in each country??___________________________________________________

select country, count(pub_id) as no_of_pubs
from pubs
group by country;

#2.______________________ What is the total sales amount for each pub, including the beverage price and quantity sold?_________________


select s.pub_id,  sum((b.price_per_unit*s.quantity)) as total_sales_amt
from pubs p inner join sales s using (pub_id) 
inner join beverages b using (beverage_id)
group by pub_id;


#3.___________________________________ Which pub has the highest average rating?______________________________________


select p.pub_id, p.pub_name, round(avg(r.rating),2) as average_rating
from pubs p inner join ratings r using(pub_id)
group by pub_id
order by 3 desc
limit 1;


#_________________________4. What are the top 5 beverages by sales quantity across all pubs?______________________________________

select beverage_id, beverage_name, sum(quantity)
from beverages b inner join sales s using(beverage_id)
group by beverage_id
order by 3 desc
limit 5;

#_____________________5. How many sales transactions occurred on each date?________________________________

select transaction_date, count(sale_id)
from sales
group by transaction_date; 

#_________________________6. Find the name of someone that had cocktails and which pub they had it in.________________________________

select pub_name, customer_name, category
from beverages b inner join sales s using(beverage_id)
inner join pubs p using (pub_id)
inner join ratings r using(pub_id)
where b.category = "Cocktail";

#________________7. What is the average price per unit for each category of beverages, excluding the category 'Spirit'?________________

select category , avg(price_per_unit)
from beverages
where category not in ("Spirit")
group by category;

#_________________________8. Which pubs have a rating higher than the average rating of all pubs?________________________________

with t1 as (select p.pub_id, p.pub_name, r.rating,
avg(r.rating) over() as overall_average_rating
from pubs p inner join ratings r using(pub_id))
select * 
from t1
where rating > overall_average_rating; 

#__________________9. What is the running total of sales amount for each pub, ordered by the transaction date?________________________

with t1 as (select s.pub_id, (b.price_per_unit*s.quantity) as total_sales_amt, transaction_date
from pubs p inner join sales s using (pub_id) 
inner join beverages b using (beverage_id))
select pub_id, total_sales_amt, transaction_date,
sum(total_sales_amt) over(partition by pub_id order by transaction_date) as running_total
from t1;


#_______________________ 10. For each country, what is the average price per unit of beverages in each category, 
			-- and what is the overall average price per unit of beverages across all categories?_____________________________________


select country, category, round(avg(price_per_unit),2) as avg_price_per_unit,
round(avg(price_per_unit) over(partition by country),2) as overall_average_price_per_unit
from beverages b inner join sales s using(beverage_id)
inner join pubs p using (pub_id)
group by country, category;


#________________11. For each pub, what is the percentage contribution of each category of beverages to the total sales amount, 
				-- and what is the pub's overall sales amount?________________________________________________________________

with t1 as (select pub_id, pub_name, category, sum((quantity*price_per_unit)) as sales
from beverages b inner join sales s using(beverage_id)
inner join pubs p using (pub_id)
group by pub_id, category),

t2 as (select pub_id, pub_name, category, sales,
sum(sales) over(partition by pub_id) as total_sales
from t1)

select pub_id, pub_name, category, sales,total_sales, round((sales/total_sales)*100,2) as percent_contribution
from t2;



