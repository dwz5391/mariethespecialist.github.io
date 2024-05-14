create table if not exists cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

select * from cars

#solution 1, unique identifer
delete from cars
where id in 
	(select id from (
					select max(id) as id
					from cars
					group by model, brand
					having count(*) >1
			) as maxid
);

#solution 2, self join
# core logic
select c2.id
from cars c1
join cars c2 on c1.model=c1.model and c1.brand=c2.brand
where c1.id<c2.id

#solution 3, using window function
select id
from (select *, row_number() over (partition by model,brand) as rn
	from cars) x
where x.rn >1;

#Solution 4, using MIN function. This delete multiple duplicate records
delete from cars
where id in 
	(select id 
    from (select id from cars
		where id not in (select min(id)
						from cars
						group by model, brand) 
		) as minx
	);
    
# solution 5, using backup table
# 1st step create an empty backup table
create table cars_bkup
as 
select * from cars where 1=2

# 2nd step, query unique record
insert into cars_bkup
select * 
from cars
where id in (select min(id)
			from cars
            group by model, brand);
# 3rd step drop original table cars
drop table cars;

#Solution 6, using backup table with out dropping table
create table cars_bkup
as 
select * from cars where 1=2

# 2nd step, query unique record
insert into cars_bkup
select * 
from cars
where id in (select min(id)
			from cars
            group by model, brand);
# 3rd step, delete all records from cars using truncate
select * from cars_bkup
truncate table cars;
select * from cars
# 4th step, insert records from backup table to orignal table, drop backup table
insert into cars
select * from cars_bkup



# When all columns are duplicated
#Solution 1, in PSQL using CTID, in Oracle, using rowid
/*
delete from cars
where id in 
	(select ctid from (
					select max(ctid) as id
					from cars
					group by model, brand
					having count(*) >1
			) as maxid
);

*/

#solution 2, create a temp unique id column
# ALTER TABLE cars ADD COLUMN row_num INT AUTO_INCREMENT PRIMARY KEY;

ALTER TABLE cars ADD COLUMN row_num INT AUTO_INCREMENT unique KEY;
#core query
select id from (
					select max(row_num) as id
					from cars
					group by model, brand
					having count(*) >1
			) as maxid
            
select * from cars
alter table cars 
drop column row_num

#Solution 3, use backup table
#core query
create table cars_bkup as
select distinct # from cars; 