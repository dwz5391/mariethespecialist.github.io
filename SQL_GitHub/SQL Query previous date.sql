/*Question #11:
Imagine there is a FULL_NAME column in a table which has values like “Elon Musk“, “Bill Gates“, “Jeff Bezos“ etc. So each full name has a first name, a space and a last name. Which functions would you use to fetch only the first name from this FULL_NAME column? Give example.

Question Level: Expect this question for beginner and intermediate level role.

Again there would be different functions in different RDBMS to perform the same operation. Let’s solve this using the four most popular RDBMS.

Oracle: We can use SUBSTR() function to get a sub string from a given text based on the start and end position. And we can use INSTR() function to find the position of a particular string in the given text. Example query below:

SELECT SUBSTR(full_name, 1, INSTR(full_name, ' ', 1, 1) - 1) as first_name FROM dual; */

# MySQL: We can use SUBSTRING() function to get a sub string from a given text based on the start and end position. And we can use INSTR() function to find the position of a particular string in the given text. Example query below:

#SELECT SUBSTRING(fullname, 1, INSTR(fullname, ' ,', 1, 1) - 1) as last_name FROM employees; this one doesn't work, use the one below
SELECT SUBSTRING_INDEX(fullname, ',', 1) as last_name FROM employees LIMIT 0, 1000;

/* Microsoft SQL Server (MSSQL): We can use SUBSTRING() function to get a sub string from a given text based on the start and end position. And we can use CHARINDEX() function to find the position of a particular string in the given text. Example query below:

SELECT SUBSTRING(full_name, 1, CHARINDEX(' ', full_name) - 1) as first_name; */

/* PostgreSQL: We can use SUBSTR() function to get a sub string from a given text based on the start and end position. And we can use POSITION() function to find the position of a particular string in the given text. Example query below:
 */
 

/*Question 23: Which function can be used to fetch yesterdays date? Provide example.

Question Level: Expect this question for beginner and intermediate level role.

Different RDBMS would have different date functions to add or subtract a day value from the current date. Let’s see the date functions to be used in the four most popular RDBMS.

Oracle: In Oracle we can simple subtract an integer from a date value hence we do not need to use a function to find yesterday’s date as shown in below query. SYSDATE will return today’s date.

SELECT SYSDATE - 1 as previous_day FROM DUAL;

MySQL: SYSDATE() will returns today’s date along with timestamp value.

Below query would return the date and timestamp. */

SELECT DATE_SUB(SYSDATE(), INTERVAL 1 DAY) as previous_day; 

/*Below query only returns the date.

SELECT DATE_SUB(CAST(SYSDATE() AS DATE), INTERVAL 1 DAY) as previous_day; 

Microsoft SQL Server (MSSQL): GETDATE() will returns today’s date along with timestamp value.

Below query would return the date and timestamp.

SELECT DATEADD(DAY, -1, GETDATE());

Below query only returns the date.

SELECT DATEADD(DAY, -1, CAST(GETDATE() AS DATE));

PostgreSQL: In PostgreSQL as well, we can simple subtract an integer from a date value hence we do not need to use a function to find yesterday’s date as shown in below query. CURRENT_DATE will return today’s date.

SELECT CURRENT_DATE - 1 as previous_day FROM DUAL;

*Note: Please note, there will be few other date functions in each of these RDBMS to perform the same operation. The above functions are just one of such functions. 
 SELECT DATE_SUB(SYSDATE(), INTERVAL 1 DAY) as previous_day;  */