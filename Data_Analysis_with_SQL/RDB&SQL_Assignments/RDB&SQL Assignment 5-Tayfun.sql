
-- ASSIGNMENT 5 --


-- Create a scalar-valued function that returns the factorial of a number you gave it.

 CREATE FUNCTION factorial (@number INT)
	RETURNS INT AS
	BEGIN 
	DECLARE 
	@i INT, @result INT 
	SET @i=1
	SET @result=1
	WHILE (@i <= @number)
	BEGIN 
	SET @result=@result * @i 
	SET @i +=1 
	END 
	RETURN @result
END 

SELECT dbo.factorial(3)

SELECT dbo.factorial(6)

SELECT dbo.factorial(3) [3!], dbo.factorial(5) [5!], dbo.factorial(7) [7!]



