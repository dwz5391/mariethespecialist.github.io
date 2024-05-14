##Part 1

use misc
create procedure usp_EmpSal as
select * from employees

#syntax for SQL Server 
# CREATE PROCEDURE USP_EMPSAL @SAL INT AS
# SELECT * FROM EMPLOYEES WHERE sALARY > @SAL

# EXEC UPS_EMPSAL
# USP_EMPSAL #OR USE THE NAME OF THE PROCECURE DIRECTION TO RUN PROCEDURE

delimiter //
CREATE PROCEDURE usp_EmpSal()
BEGIN
    SELECT * FROM employees; #note: make sure ";" is used here
END // # make sure "//" is used here
delimiter ; # make sure add a space here before ";"

# exec usp_EmpSal or use procedure name direction to run proceduure is the syntax of SQL Server, not for MySQL
call usp_EmpSal() # this is the syntax for MySQL

# drop procedure usp_EmpSal1
delimiter //
CREATE PROCEDURE usp_EmpSal(IN Sal INT)
BEGIN
    SELECT * FROM employees
    WHERE Salary > Sal; 
END // 
delimiter ; 

call usp_EmpSal_1(50000)


DELIMITER //
DROP PROCEDURE IF EXISTS usp_EmpSal;   #MySQL doesn't support alter to change procedure
CREATE PROCEDURE usp_EmpSal()
BEGIN
    SELECT Salary FROM employees;
END //
DELIMITER ;

call usp_EmpSal()





## Part 2

use classicmodels
select * from customers

#Stored Procedure
delimiter &&
create procedure somecust()
begin
	select customerNumber, customerName
	from customers where customerNumber = 103;
end &&
delimiter ;

call somecust()

delimiter //
create procedure prod_sortByPrice(IN var int)
begin
select productName, buyPrice from products
order by buyPrice desc limit var;
end //
delimiter ;

call prod_sortByPrice(3)


use classicmodels
select distinct status from orders #where status = 'On Hold' orderNumber = '10334' change to 'Shipped'--

delimiter //
create procedure update_order_status(IN temp_ordNum varchar(20), IN new_status varchar(20))
begin
update orders set
status = new_status where orderNumber = temp_ordNum;
end;
#drop procedure update_orders
select * from orders where status = 'On Hold'

select * from orders where orderNumber = '10334'

call update_order_status ('10334','On Hold')


use classicmodels
#SP using OUT

delimiter //
create procedure sp_CountOrders(OUT Total_Ords int)
begin
select count(orderNumber) into Total_Ords from Orders
where status = 'On Hold';
end //
delimiter ;
call sp_CountOrders(@On_Hold_ords);
select @On_Hold_ords as On_Hold_Orders

#Trigger in SQL

create table student
(st_roll int, age int, name varchar(30), mark float)

delimiter //
create trigger marks_verify
before insert on student
for each row
if new.mark <0 then set new.mark=50;
end if;//

insert into student
values 
(501,10,'Ruth',75.0),
(502,12,'Mike',-20.5), 
(503,13,'Dave', 90.0), 
(504,10,'Jacobs', -20.5)
use classicmodels
select * from student;
#drop trigger marks_varify

#Windows function

select name, mark, age, avg(mark) over (partition by age) as mark_avg_by_age
from student;

#Row number

select row_number() over(order by mark) as row_mnum, name, mark from student order by mark desc;

create table demo(st_id int, st_name varchar(20));
insert into demo
values(101,'Shane'),
(102, 'Bradley'),
(103,'Herath'),
(103,'Herath'),
(104,'Nathan'),
(105,'Kevin'),
(105,'Kevin');

select * from demo;

select st_id,st_name, row_number() over
(partition by st_id, st_name order by st_id) as row_num
from demo;

#Rank function

create table demo_1(var_a int);

insert into demo_1
value(101),(102),(103),(104),(105),(106),(106),(107)


select var_a, 
rank() over (order by var_a) as test_rank
from demo_1;

#First_value()

select name, age, mark, first_value(name)
over (order by mark desc) as highest_mark from student;

select name, age, mark, first_value(name)
over (partition by age order by mark desc) as highest_mark_by_age
from student;

use moviesdb
#Having usage, 1) must be in this order: FROM->WHERE->GROUP BY->HAVING->ORDER BY; 2) having column has to be in the select part of query

select release_year, count(*) as movies_count 
from movies 
group by release_year
having movies_count >2
order by movies_count desc;

select *, year(curdate())-birth_year as age from actors;

select *, if(currency='USD', revenue*77, revenue) as revenue_inr
from moviesdb.financials;

select *, 
	CASE
		WHEN unit='thousands' THEN revenue/1000
        WHEN unit = 'billions' THEN revenue*1000
        ELSE revenue #WHEN unit = 'millions' THEN revenue
	END as revenue_mln
FROM moviesdb.financials;

#Full join in MySQL uses UNION

select m.movie_id, title, budget, revenue, currency, unit
from movies m left join financials f 
on m.movie_id = f.movie_id
union
select f.movie_id, title, budget, revenue, currency, unit
from movies m right join financials f 
on m.movie_id = f.movie_id;

#"USING" IN QUERY, when column name is identical with two tables

SELECT movie_id, title, budget, revenue, currency, unit
FROM movies m
RIGHT JOIN financials f
USING(movie_id)