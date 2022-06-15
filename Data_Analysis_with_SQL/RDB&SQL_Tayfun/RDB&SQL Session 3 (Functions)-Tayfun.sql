
--RDB&SQL Session 3--

--Functions--



--Date Functions

CREATE TABLE t_date_time (
	A_time time,
	A_date date,
	A_smalldatetime smalldatetime,
	A_datetime datetime,
	A_datetime2 datetime2,
	A_datetimeoffset datetimeoffset
	)

select *
from t_date_time

-- getdate() function brings date


SELECT GETDATE() as get_date

INSERT t_date_time
VALUES ( GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())

INSERT t_date_time (A_time, A_date, A_smalldatetime, A_datetime, A_datetime2, A_datetimeoffset)
VALUES 
('12:00:00', '2021-07-17', '2021-07-17','2021-07-17', '2021-07-17', '2021-07-17' )


---Convert function changes the type of an data to a different type 


SELECT  GETDATE()

--changed the date to varchar

SELECT CONVERT(VARCHAR(10), GETDATE(), 6)

--changed varchar to date 

SELECT CONVERT(DATE, '04 Jun 22' , 6)

SELECT CONVERT(DATETIME, '04 Jun 22' , 6)




----DATE FUNCTIONS



---Functions for return date or time parts

SELECT A_DATE
		, DAY(A_DATE) DAY_
		, MONTH(A_DATE) [MONTH]
		, DATENAME(DAYOFYEAR, A_DATE) DOY
		, DATEPART(WEEKDAY, A_date) WKD
		, DATENAME(MONTH, A_DATE) MON
FROM t_date_time


--- DATEIFF function gives the difference between two dates as day, hours or any times 

SELECT DATEDIFF(DAY, '2022-05-10', GETDATE())


SELECT DATEDIFF(SECOND, '2022-05-10', GETDATE())



-- Find the difference between order dates and shipped dates as a day 


SELECT	*, DATEDIFF(DAY, order_date, shipped_date) Diff_of_day
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



SELECT	*
FROM	sale.orders
WHERE	DATEDIFF(DAY, order_date, shipped_date) > 2



--DATEADD function 

-- DATEADD function adds day or any time to the date. 


SELECT DATEADD(DAY, 5, GETDATE())

SELECT DATEADD(MINUTE, 5, GETDATE())



--EOMONTH (End of month) function 

-- EOMONTH function gives the date of end of month. 



SELECT EOMONTH(GETDATE())


-- This gives the date of the end of two month later


SELECT EOMONTH(GETDATE(), 2)   


--LEN function returns the number of characters of a character string 

--CHARINDEX function returns the position of a substring within a specified string 

--PATINDEX function returns the starting position of the first occurrence of a pattern in a string



SELECT LEN ('CHARACTER')


SELECT LEN ('CHARACTER ')

SELECT LEN (' CHARACTER ')

----

SELECT CHARINDEX('R', 'CHARACTER')

SELECT CHARINDEX('R', 'CHARACTER', 5)

SELECT CHARINDEX('RA', 'CHARACTER')

SELECT CHARINDEX('R', 'CHARACTER', 5) - 1

----


SELECT PATINDEX('%r', 'CHARACTER')

SELECT PATINDEX('%R', 'CHARACTER')

SELECT PATINDEX('%H%', 'CHARACTER')


SELECT PATINDEX('%A%', 'CHARACTER')

SELECT PATINDEX('__A______', 'CHARACTER')

SELECT PATINDEX('__A%', 'CHARACTER')

SELECT PATINDEX('____A%', 'CHARACTER')

SELECT PATINDEX('%A____', 'CHARACTER')





--LEFT function returns a given number of characters from a character string starting from the left 

--RIGHT function returns a given number of characters from a character string starting from the right

--SUBSTRING returns a substring within a string starting from a specified location with a specified length 


SELECT LEFT('CHARACTER', 3)

SELECT RIGHT('CHARACTER', 3)

SELECT SUBSTRING('CHARACTER', 3, 5)


SELECT SUBSTRING('CHARACTER', 4, 9)





--LOWER function convert a string  to lowercase  
 
--UPPER  function convert a string  to uppercase  
 
-- STRING_SPLIT function splits a string


SELECT LOWER('CHARACTER')


SELECT UPPER('character')



SELECT *
FROM STRING_SPLIT('jack,martin,alain,owen', ',') 

SELECT value
FROM STRING_SPLIT('jack,martin,alain,owen', ',') 

SELECT value as name
FROM STRING_SPLIT('jack,martin,alain,owen', ',') 



----


--- write a script that  returns that makes the first letter of 'character' word  uppercase


SELECT UPPER ('character')


SELECT UPPER (LEFT('character', 1))


SELECT SUBSTRING('character', 2, 9)

select LEN('character')


SELECT LOWER (SUBSTRING('character', 2, LEN('character')))

SELECT UPPER (LEFT('character', 1)) + LOWER (SUBSTRING('character', 2, LEN('character')))


SELECT CONCAT (UPPER(LEFT('character', 1)) , LOWER (SUBSTRING('character', 2, LEN('character'))))

---


-- TRIM funtion returns a new string from a specified string after removing all leading and trailin blanks or characters 
--https://docs.microsoft.com/en-us/sql/t-sql/functions/trim-transact-sql
-- LTRIM function returns a new string from a specified string after removing all leading blanks 
--https://docs.microsoft.com/en-us/sql/t-sql/functions/ltrim-transact-sql
-- RTIM function returns a new string from a specified string after removing all trailing blanks 
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/rtrim-transact-sql



SELECT TRIM(' CHARACTER');

SELECT ' CHARACTER';

SELECT TRIM(' CHARACTER ')

SELECT TRIM(      '          CHAR ACTER          ')


-- If there is more than one character that we want to trim, we can specify them as follows
SELECT TRIM('ABC' FROM 'CCCCBBBAAAFRHGKDFKSLDFJKSDFACBBCACABACABCA')

--When it encounters any character in the expression we entered, this character will be deleted. Until it meets another character besides these characters.

SELECT	TRIM('X' FROM 'ABCXXDE')

SELECT	TRIM('x' FROM 'XXXXXXXXABCXXDEXXXXXXXX')


SELECT LTRIM ('     CHARACTER ')

SELECT RTRIM ('     CHARACTER ')


-- REPLACE function replace all occurrences of a substring, within a string with another substring
--https://docs.microsoft.com/en-us/sql/t-sql/functions/replace-transact-sql
-- STR funtion returns character data converted from numneric data. 

-- https://docs.microsoft.com/en-us/sql/t-sql/functions/str-transact-sql


SELECT REPLACE('CHA   RACTER     STR   ING', ' ', '/')

SELECT REPLACE('CHARACTER STRING', 'CHARACTER STRING', 'CHARACTER')

SELECT STR (5454)

SELECT STR (2135454654)

SELECT STR (133215.654645, 11, 3)

SELECT len(STR(1234567823421341241290123456))


-- CAST function cast a value  of one type to another type

-- CONVERT function convert a value of one type to another type 

-- https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql



SELECT CAST (12345 AS CHAR)

SELECT CAST (123.65 AS int)


SELECT CONVERT(int, 30.60)

SELECT CONVERT (VARCHAR(10), '2020-10-10')

SELECT CONVERT (DATETIME, '2020-10-10' )

SELECT CONVERT (NVARCHAR, GETDATE(), 112 )

SELECT CAST ('20201010' AS DATE)



-- COALESCE function return first not null data in datas 

-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/coalesce-transact-sql

SELECT COALESCE(NULL, 'Hi', 'Hello', NULL)


-- NULLIF function returns NULL if two data are equal or first value if they are not equal.

-- https://docs.microsoft.com/en-us/sql/t-sql/language-elements/nullif-transact-sql

SELECT NULLIF (10,10)

SELECT NULLIF(10, 11)


-- ROUND function rounds a number to a specified number of decimal places

--https://docs.microsoft.com/en-us/sql/t-sql/functions/round-transact-sql

--The third parameter is used to determine whether the result should be rounded up or down.
-- It is set to 0 (ie rounding up) by default. Write 1 to round down.


SELECT ROUND (432.368, 2, 0)
SELECT ROUND (432.368, 2, 1)
SELECT ROUND (432.368, 2)

-- ISNULL function replaces NULL with specified repalcement value 

-- https://docs.microsoft.com/en-us/sql/t-sql/functions/isnull-transact-sql

SELECT ISNULL(NULL, 'ABC')

SELECT ISNULL('', 'ABC')

-- ISNUMERIC function returns 1 if the value is numeric, 0 if the value is not numeric. We can decide by this function whether a value is numeric or not. 

-- https://docs.microsoft.com/en-us/sql/t-sql/functions/isnumeric-transact-sql


select ISNUMERIC(123)

select ISNUMERIC('ABC')
