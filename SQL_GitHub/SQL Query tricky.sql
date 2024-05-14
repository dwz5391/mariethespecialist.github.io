use misc
create table comments_and_translations
(
	id				int,
	comment			varchar(100),
	translation		varchar(100)
);

insert into comments_and_translations values
(1, 'very good', null),
(2, 'good', null),
(3, 'bad', null),
(4, 'ordinary', null),
(5, 'cdcdcdcd', 'very bad'),
(6, 'excellent', null),
(7, 'ababab', 'not satisfied'),
(8, 'satisfied', null),
(9, 'aabbaabb', 'extraordinary'),
(10, 'ccddccbb', 'medium');
commit;

select * from comments_and_translations

#get meaningfull comments from comments_and_translations table
# solution 1, using union 
select comment 
from comments_and_translations
where translation is null
union all
select translation
from comments_and_translations
where translation is not null

#solution 2 using case

select case when translation is null
				then comment
			else translation
		end as output
from comments_and_translations;

#solution 3, using coalesce
select coalesce(translation,comment) as output
from comments_and_translations;

create table source
(id int,
name varchar (2)
);

select * from source
insert into source 
values (
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D')
		);