#query N consecutive records with a condition
# 5 consecutive records 
use misc
select * from misc.temperature

select date,
str_to_date(date,'%m/%d/%Y')
from temperature

ALTER TABLE temperature
MODIFY COLUMN date DATE;

select * ,
row_number() over(order by seq) as rn,
seq - (row_number() over(order by seq)) as difference
from temperature
where temperature <0

with t1 as
		(select * ,
		row_number() over(order by seq) as rn,
		seq - (row_number() over(order by seq)) as difference
		from temperature
		where temperature <0
		),
	t2 as
		(select *, count(*) over (partition by difference) as no_of_records
        from t1
        )
select *
from t2
where no_of_records >3;

#Version 2 Excerise, no primary key present in table/view, only two columns, city and temperature, 1st step to add a row number


create view vw_weather as
select city, temperature from temperature

select * from vw_weather

with w as
		(select *, row_number() over() as id
        from vw_weather),
	t1 as
		(select * ,
		row_number() over(order by id) as rn,
		id - (row_number() over(order by id)) as difference
		from w
		where temperature <0
		),
	t2 as
		(select *, count(*) over (partition by difference) as no_of_records
        from t1
        )
select *
from t2
where no_of_records >3;

#version 3, using date column to get the consecutive count

DELETE FROM orders
WHERE order_Date = 'Order_Date';

select order_date,
str_to_date(order_date,'%m/%d/%Y')
from orders

SELECT order_date FROM orders WHERE STR_TO_DATE(order_date, '%m/%d/%Y') IS NULL;

UPDATE orders
set order_date = str_to_date(order_date,'%m/%d/%Y')

ALTER TABLE orders
MODIFY COLUMN order_date DATE;

select *
, row_number() over (order by oder_id) as rn
, order_date - cast(row_number() over (order by oder_id) as signed) as difference
from orders;

with t1 as
		(select *
		, row_number() over (order by oder_id) as rn
		, order_date - cast(row_number() over (order by oder_id) as signed) as difference
		from orders
        ),
      t2 as 
		(select *, count(*) over (partition by difference) as no_of_records
        from t1
        )
Select *
from t2
where no_of_records = 3;