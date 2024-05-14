CREATE TABLE misc.Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName NVARCHAR(250) NOT NULL,
    DeptID INT NULL,
    Salary INT NULL,
    HireDate DATE NULL,
    ManagerID INT NULL
);

INSERT INTO Employees (EmployeeID, FullName, DeptID, Salary, HireDate, ManagerID) 
VALUES 
(1, 'Owens, Kristy', 1, 35000, '2018-01-22', 3),
(2, 'Adams, Jennifer', 1, 55000, '2017-10-25', 5),
(3, 'Smith, Brad', 1, 110000, '2015-02-02', 7),
(4, 'Ford, Julia', 2, 75000, '2019-08-30', 5),
(5, 'Lee, Tom', 2, 110000, '2018-10-11', 7),
(6, 'Jones, David', 3, 85000, '2012-03-15', 5),
(7, 'Miller, Bruce', 1, 100000, '2014-11-08', NULL),
(9, 'Peters, Joe', 3, 11000, '2020-03-09', 5),
(10, 'Joe, Alan', 3, 11500, '2020-03-09', 5),
(11, 'Clark, Kelly', 2, 11500, '2020-03-09', 5);

# Question # 1: find out hightest salary employee in a department, keys: 1) inner join, 2) aggregated column max(salary) needs a alias
# version one
select emp1.deptid, employeeid, fullname, salary from employees emp1
inner join (select deptid, max(salary) as m_salary from employees group by deptid) as emp2
on emp1.salary = emp2.m_salary
and emp1.deptid = emp2.deptid;

#version two note: the query is from SQL Server, it doesn't work in MySQL
select employeeid, fullname, deptid, salary
from
(
select employeeid, fullname, deptid, salary,
		rank() over (partition by deptid order by salary desc) as sal
from employees
) as emp
where sal =1

# Question # 2: find the employee whoes salary is less than the average of the department

select count (*) from employees

select emp.deptid, emp.employeeid,emp.salary, ds.avg_sal 
from employees emp 
inner join
(
select deptid, avg(salary) as avg_sal from employees
group by deptid 
) as ds
on emp.deptid=ds.deptid 
and emp.salary < ds.avg_sal;

#Question 3: find employees with salary lesser than department average but greater than the average of any other department

with t1 as
		(select emp.deptid, #emp.employeeid,
		emp.salary, ds.avg_sal 
		from employees emp 
		inner join
			(
			select deptid, avg(salary) as avg_sal from employees
			group by deptid 
			) as ds
		on emp.deptid=ds.deptid 
		and emp.salary < ds.avg_sal
		order by ds.avg_sal)
        ,
    t2 as
		(select min(avg_sal) as min_dept_sal
		from t1
        #group by t1.salary
        ),
	t3 as
		(select t1.*, t2.min_dept_sal
        from t1 inner join t2
        on t1.Salary > t2.min_dept_sal #> (select * from t2)
        )
select * from t3;

# Question 4: find out employees with the same salary

select e.employeeid, e.salary from employees e
inner join 
(Select salary, count(salary) as c_sal from employees group by salary having count(salary) >1) as ds
on e.salary = ds.salary;

# Question #5: find dept where no emplopyee has a salary greater than his manager's salary; 
#1st step, find an employee whoes salary is greater than his manager, based on his dept, find out the rest of dept

#update employees
#set salary = 65000
#where employeeid = 3

select * from employees
where employeeid != managerid

select distinct deptid from employees
where deptid <> 
(
select e.deptid from employees e 
inner join employees m
on e.managerid = m.employeeid
where e.salary >m.salary)

#question 6: find difference between employee salary and average salary of department

# version 1 regular way
select (salary- avg_sal_dept) sal_diff
from employees e
inner join (
	select deptid, avg(salary) avg_sal_dept
	from employees group by deptid) d
    on e.deptid=d.deptid

# version 2 using partition
select salary -avg(salary) over (partition by deptid) as diffsal
from employees;

#question # 7: find employee whose salary is in top 2 percentile of in their department
select * from employees
order by deptid, salary desc

select employeeid, salary, rk
from 
	(SELECT employeeid, salary, deptid,
	PERCENT_rank() OVER (PARTITION BY deptid order by salary) AS rk
	FROM employees) as pt
where rk > 0.98

#question #8: find employees who can earn more than every employee in dept 2
# version 1
Select employeeID, salary
from employees
where salary > all
	(select salary
    from employees where deptid =2
    )
#version 2
select employeeid, salary
from employees where salary > (select max(salary) from employees where deptid =2 order by salary desc);

#question 9: find dept and employees names that has more than two employees
# and salary is greater than 90% of respective department average salary

select t.deptid, count(t.deptid) as ct_deptid 
from
	(select emp.employeeid, emp.fullname, emp.salary, emp.deptid, dt.avg_sal*0.9 as 90_avg_sal
	from employees emp
	inner join 
		(select deptid, avg(salary) as avg_sal
		from employees
		group by deptid) dt
	where emp.deptid = dt.DeptID
	having emp.salary > 90_avg_sal) as t
group by t.deptid
having count(t.deptid)>=2


SELECT t.deptid, COUNT(t.deptid) AS ct_deptid  
FROM (
    SELECT emp.employeeid, emp.fullname, emp.salary, emp.deptid, dt.avg_sal * 0.9 AS 90_avg_sal  
    FROM employees emp  
    INNER JOIN (
        SELECT deptid, AVG(salary) AS avg_sal   
        FROM employees   
        GROUP BY deptid
    ) dt  
    ON emp.deptid = dt.deptid  
    WHERE emp.salary > dt.avg_sal * 0.9
) AS t 
GROUP BY t.deptid
HAVING COUNT(t.deptid) >= 2;

#version 3
select distinct deptid 
from
		(select employeeid, deptid, 
        sum(case when salary >0.9* avgsal then 1
			else 0 end) over (partition by deptid) as empcnt
		from
			(select employeeid, deptid, salary, avg(salary) over (partition by deptid) as avgsal
			from employees) as emp
		) emp1
where empcnt>=2


#question # 10: Select Top 3 departments with at least two employees 
#and rank them according to the percentage of their employees making over 100K in salary 

update employees
set salary = 110000
where employeeid =3

SELECT deptid, 
       100 * SUM(CASE WHEN salary >= 100000 THEN 1 ELSE 0 END) / COUNT(employeeid) 
FROM employees 
GROUP BY deptid 
ORDER BY SUM(CASE WHEN salary >= 100000 THEN 1 ELSE 0 END) / COUNT(employeeid) DESC 
LIMIT 2;