select * from logon

#DELETE FROM logon
#WHERE time ='' and status = ''

# create id and rn, the key is creating rn with a condition of status as 'on' to differenciate the records from 'off'
with w as
		(select *, row_number() over() as id
        from logon),
	t1 as
		(select * ,
		row_number() over(order by id) as rn,
		id - (row_number() over(order by id )) as difference
		from w
        where status = 'on'
		),
	t2 as
		(select *, count(*) over (partition by difference) as no_of_records
        from t1
        )
select *
from t2
;

