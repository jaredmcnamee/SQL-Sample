/*Q1.
Generate and save a random value as a whole number between 1 and 100 inclusive, use an
if/else to determine if the value is divisible by 3 setting an appropriate variable to “Yes' or 'No'.
Write the select to output the number and the determination as :
*/
Declare @rValue as int
Declare @yesNo as varchar(3)

set @rValue = round(Rand()*101+1,0,1)

if @rvalue % 3 = 0
	set @yesNo = 'Yes'
else
	set @yesNo = 'No'

select
	@rValue as 'Random Number',
	@yesNo as 'Factor of 3'
go

/*
Q2.
Generate and save a random value as a whole number between 1 and 60 inclusive representing
the minutes. Then using a searching case statement, determine and set an appropriate variable
based on these criteria :
1. up to but not including 15 minutes : “on the hour”
2. up to but not including 30 minutes : “quarter past”
3. up to but not including 45 minutes : “half past”
4. catch the remainder as “quarter to”
Write the select to output the number and its approximation as :
*/
Declare @minutes as int
Declare @minMessage as varchar(12)

set @minutes = ROUND(rand()*61+1,0,1)

set @minMessage = case
	when @minutes < 15 then 'on the hour'
	when @minutes < 30 then 'quarter past'
	when @minutes < 45 then 'half past'
	when @minutes >= 45 then 'quarter to'
end

Select 
	@minutes as 'Minutes',
	@minMessage as 'Ballpark'

/*
Q3.
Using getdate(), add a random number of days between 0 and 6 inclusive, using this value
determine the day of the week and save. Using a simple matching case statement, set a status
value to “Yahoo” if it represents a weekend day, or “Got Class” if it is a weekday.
Write a select to output the day of the week generated and its status determination as :
*/

Declare @rand as int

Declare @dMessage as varchar(9)

set @rand = ROUND(rand()*7,0,1)
Declare @DOW as varchar(12) = dateadd(DW,@rand,Getdate())

set @dMessage =
		case datename(dw,@DOW)
			when 'Saturday' then 'Yahoo'
			when 'Sunday' then 'Yahoo'
			else 'Got Class'
		end

select 
		datepart(dw,@DOW) as 'day name',
		@dMessage as 'Status'
go

/*
Q4.
A number of numeric variables are required for this looping question. Generate a total iteration
value between 1 and 10000 and save. Repeat for this iteration count, and :
1. Generate a new random value between 1 and 10 inclusive, save, then,
2. If the number is divisible by 2, increment a variable to track this condition
3. If the number is divisible by 3, increment a variable to track this condition
4. If the number is divisible by 5, increment a variable to track this condition
*/

Declare @numItTotal as numeric = round(rand()*10001+1,0,1)
Declare @numItCurr as numeric = 1
Declare @testNum as numeric
Declare @fac2 as numeric = 0
Declare @fac3 as numeric = 0
Declare @fac5 as numeric = 0

while @numItCurr <= @numItTotal
begin
	set @testNum = round(rand()*11+1,0,1)
	if @testNum % 2 = 0
		set @fac2 = @fac2+1
	if @testNum % 3 = 0
		set @fac3 = @fac3+1
	if @testNum % 5 = 0
		set @fac5 = @fac5+1
	set @numItCurr = @numItCurr+1
end

select
	convert(varchar(20),@numItTotal) as 'Number of Iterations',
	convert(varchar(11),@fac2) as 'Factor of 2',
	convert(varchar(11),@fac3) as 'Factor of 3',
	convert(varchar(11),@fac5) as 'Factor of 5'
go
	
/*
Q5.
In this question we will use circular inclusion to approximate the value of PI.As PI is the ratio of the
area inside a circle vs the area of its bounding box, we can generate random points that will drive
us close to a good approximation. We will simplify our guessing by using the positive quadrant of
a 200x200 circle, so a 100x100 box. So for up to 1000 guesses repeat :
1. generate a random X value in our box
2. generate a random Y value in our box
3. determine if the x and y are inside the quarter circle of our box, if so increment an “in” value
4. increment our guess/count value
5. determine the approximate PI value => 4 ( in / total )
Rinse and Repeat - but once you have it working, add an additional criteria to your loop construct,
such that it will stop when the difference of our guess to the actual value of PI is less or equal to
0.0002. ( pretty close ). You will find it often stops before all 1000 guesses have been made.
** Use decimal to 9 places for your PI approximation, and appropriate types to get the arithmetic
resolution you need.
*/

declare @xval as int
declare @yval as int
declare @guesses as int = 1
declare @inVal as float = 0
declare @aPi as float(9) 
declare @radius as float
declare @bool as tinyint = 1

while (@bool = 1  and @guesses < 1000)
begin
	set @xval = rand()*101
	set @yval = rand()*101

	print @xval
	print @yval

	set @radius = SQRT(SQUARE(@xval) + Square(@yval))

	if(@radius <= 100)
		set @inVal = @inVal + 1
	set @guesses = @guesses + 1
	set @aPi = 4.0 * (@inVal / @guesses)

	if(ABS(@aPi - PI()) <= 0.0002)
		set @bool = 0
end

select 
	cast(@aPi as decimal(11,9)) as "Estimate",
	pi() as "Pi",
	@inVal as "In Values",
	@guesses as "Tries"
go
