Question #10:
/*How can you convert a text into date format? Consider the given text as “31-01-2021“.

Question Level: Expect this question for beginner intermediate and senior level role.

Different RDBMS would have different date functions to convert a text to date format. Let’s see the date functions to be used in the four most popular RDBMS as of today.

Oracle: 

SELECT TO_DATE('31-01-2021', 'DD-MM-YYYY') as date_value FROM DUAL; */

#MySQL:
SELECT DATE_FORMAT('2021-01-31', '%d-%m-%Y') as date_value;
# SELECT DATE_FORMAT('31-01-2021', '%d-%m-%Y') as date_value; returns null value; the correct one is above

/*Microsoft SQL Server (MSSQL):

SELECT CAST('31-01-2021' as DATE) as date_value;

PostgreSQL:

SELECT TO_DATE('31-01-2021', 'DD-MM-YYYY') as date_value;

*Note: Please note, there will be few other date functions in each of these RDBMS to perform the same operation. 
The above functions are just one of such functions. */