
create table employee_hierarchy
(
emp_id int,
reporting_id int
);

insert into employee_hierarchy (emp_id, reporting_id)
values
(1,null),
(2,1),
(3,1),
(4,2),
(5,2),
(6,3),
(7,3),
(8,4),
(9,4)
;

select * from employee_hierarchy

# hierarchy 0 (self) and 1 level only
with recursive cte as 
	(select emp_id, emp_id as  emp_hier
     from employee_hierarchy #where emp_id = 1
    union
    select cte.emp_id, eh.emp_id as emp_hier
        from cte
        join employee_hierarchy eh
        on cte.emp_id = eh.reporting_id
    )
        select * from cte
 
 
 #hierarchy all levels       
with recursive cte as 
	(select emp_id, emp_id as  emp_hierarchy
     from employee_hierarchy #where emp_id = 3
    union all
    select cte.emp_id, eh.emp_id as emp_hierarchy
        from cte
        join employee_hierarchy eh
        on cte.emp_hierarchy = eh.reporting_id
    )
select * from cte
order by 1,2
        
# breakdown 1st iteration
 select emp_id, emp_id as  emp_hier
     from employee_hierarchy where emp_id = 9
     
# 2nd iteration
select cte.emp_id, eh.emp_id as emp_hier
from (select emp_id, emp_id as  emp_hier
     from employee_hierarchy where emp_id = 1
     ) cte
join employee_hierarchy eh on cte.emp_id = eh.reporting_id

#3rd iteration
select cte.emp_id, eh.emp_id as emp_hier
from (select cte.emp_id, eh.emp_id as emp_hier
	from (select emp_id, emp_id as  emp_hier
		 from employee_hierarchy where emp_id = 1) cte
		join employee_hierarchy eh on cte.emp_id = eh.reporting_id) cte
join employee_hierarchy eh on cte.emp_hier = eh.reporting_id  # was cte.emp_id=eh.reporting_id wrong one