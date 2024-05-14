use misc
#Part 1

drop table employee;
create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;

# MAX, MIN, AVG

select e.*,
max(salary) over (partition by dept_name) as max_dept_salary
from employee e
;

select e.*,
min(salary) over (partition by dept_name order by SALARY) as min_dept_salary
from employee e
;

select e.*,
avg(salary) over (partition by dept_name) as AVG_dept_salary
from employee e
;

# Fetch the first 2 employees from each department to join the company

select *
from (
	select e.*,
	row_number() over (partition by dept_name order by emp_id) as rn
	from employee e) as emp
where emp.rn <3
;
#Fetch the top 3 employees in each department earning the max salary
# dense_rank vs. rank: dense rank goes to 3, rank goes to 4 when running into duplicated records at 2 spot

select *
from(
	select *, 
    rank() over (partition by dept_name order by salary desc) as rnk,
	dense_rank() over (partition by dept_name order by salary desc) as d_rnk
	from employee
    ) as x
where x.d_rnk <4

#LEAD() AND LAG()

SELECT E.*,
lag(salary, 2, 0) over (partition by dept_name order by emp_id) as prev_salary,
lead(salary, 2, 0) over (partition by dept_name order by emp_id) as next_salary
from employee e;

SELECT E.*,
lag(salary) over (partition by dept_name order by emp_id) as prev_salary,
lead(salary, 2, 0) over (partition by dept_name order by emp_id) as next_salary,
case when e.salary > lag(salary) over (partition by dept_name order by emp_id) then 'High'
	when e.salary < lag(salary) over (partition by dept_name order by emp_id) then 'Low'
    when e.salary = lag(salary) over (partition by dept_name order by emp_id) then 'Same'
    end sal_range
from employee e;


#Part 2
CREATE TABLE product
( 
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);

INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
COMMIT;

# first_value
# display the most expensive product under each category (corresponding to each record)
select product_category, max(price) from product group by product_category
select *,
first_value(product_name) over (partition by product_category order by price desc) as most_exp_prod
from product;

# display the least expensive product under each category (corresponding to each record)
#Last value, note: frame plays a big role to last value, end or aggregate scenarios

select *,
first_value(product_name) 
	over (partition by product_category order by price desc) 
	as most_exp_prod,
last_value(product_name) 
	over (partition by product_category order by price desc
	range between unbounded preceding and unbounded following) as least_exp_prod,
last_value(product_name) 
	over (partition by product_category order by price desc
    rows between unbounded preceding and current row) as least_exp_prod_1, #when price has duplicates, this syntax return different product_name
last_value(product_name) 
	over (partition by product_category order by price desc
    range between unbounded preceding and current row) as least_exp_prod_2, #when price has duplicates, this syntax return the same - (last one) product_name
last_value(product_name) 
	over (partition by product_category order by price desc
    range between 2 preceding and 2 following) as least_exp_prod_3 # 2 rows before the current row and 2 rows after current row making the frame
from product
where product_category = 'Phone';

##Alternative way to write SQL query using Window
select *,
first_value(product_name) over w as most_exp_prod,
last_value(product_name) over w as least_exp_prod
from product
#where product_category = 'Phone'
window w as (partition by product_category order by price desc
	range between unbounded preceding and unbounded following
			);
            
##NTH values
## Write query to display the second most expensive product under each category
select *,
first_value(product_name) over w as most_exp_prod,
last_value(product_name) over w as least_exp_prod,
nth_value(product_name, 2) over w as second_most_exp_prod,
nth_value(product_name, 5) over w as second_most_exp_prod #where there is less 5 records in the category, null is returned
from product
#where product_category = 'Phone'
window w as (partition by product_category order by price desc
	range between unbounded preceding and unbounded following
			);
            
##NTILE
##Write a query to segregate all the most expensive phones, mid range phones and the cheap phones
select *,
ntile(3) over (order by price desc) as buckets
from product
where product_category = 'Phone'


select product_name, 
case when x.buckets =1 then 'Expensive Phones'
	 when x.buckets =2 then 'Mid Range Phones'
	 when x.buckets =3 then 'Cheap Phones' end phone_category
from (
	select *,
	ntile(3) over (order by price desc) as buckets
	from product
	where product_category = 'Phone'
    ) as x ;
    
##CUME_DIST (cumulative distribution);
/* Value --> 1 <=CUME_DIST >0 */
/* Formula = Current Row no (or Row No with value same as current row)/Total no of rows */

##Query to fetch all products which are constituting the first 30% of the data in products table based on price

select product_name, 
concat(cume_dist_percentage,'%') as cume_dist_percentage, ## use concat() to add % sign
x.cume_dist_percentage
from (
	select *,
    cume_dist() over (order by price desc) as cume_distribution,
    round(cume_dist() over (order by price desc)*100,2) as cume_dist_percentage
    from product) x
where x.cume_dist_percentage <= 30;

# PERCENT_RANK (relative rank of the current row/percentage rank ing)
/* Value --> 1 <= PERCENT_RANK >0 */
/* Formula = Current Row No -1/Total no of rows -1 */

# Query to identify how much percentage more expensive is "Gaaxy Z fold 3" when compared to all product

select product_name, per_rank
from (
		select *, 
		percent_rank() over (order by price) as percentage_rank,
		round(percent_rank() over (order by price)*100,2) as per_rank
		from product
		) as x
where x.product_name = 'Galaxy Z Fold 3';
