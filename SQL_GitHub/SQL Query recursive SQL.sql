# Q1: Display number from 1 to 10 without using any in built functions

with recursive numbers as 
	(select 1 as n
    union
    select n+1 
    from numbers
    where n <10
    )
select * from numbers;

# Q2: Find the hierarchy of employees under a given manager 'Miller, Bruce'
use misc
select * from employees

with recursive emp_hierarchy as
	(select employeeid, fullname, managerid
    from employees where employeeid = 7
    union
    select e.employeeid, e.fullname, e.managerid
    from emp_hierarchy h
    join employees e on h.employeeid = e.managerid
    )
select h2.employeeid as emp_id, h2.fullname as emp_name, e2.fullname as manager_name
from emp_hierarchy h2
join employees e2 on e2.employeeid= h2.managerid; #self join to get the mapping between employees and their managers

#Question # 3: Find the hierarchy of managers for a given employee "Jones, David"

with recursive emp_hierarchy as
	(select employeeid, fullname, managerid
    from employees where fullname='Jones, David'
    union
    select e.employeeid, e.fullname, e.managerid
    from emp_hierarchy h
    join employees e on h.managerid = e.employeeid
    )
select h2.employeeid as emp_id, h2.fullname as emp_name, e2.fullname as manager_name
from emp_hierarchy h2
join employees e2 on e2.employeeid= h2.managerid; #self join to get the mapping between employees and their managers
