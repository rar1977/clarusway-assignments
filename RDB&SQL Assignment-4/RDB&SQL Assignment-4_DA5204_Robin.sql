-- Factorial Function
-- Create a scalar-valued function that returns the factorial of a number you gave it.

Create function factorial(@number int)
    returns int
    as 
    begin
        Declare @i int = 1,@result int=1
        while (@i<=@number)
    Begin
        Set @result = @result * @i
        Set @i += 1
    End
return @result
End

Select  dbo.factorial(5)