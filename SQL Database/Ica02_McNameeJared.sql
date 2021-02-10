--Ica02 Jared McNamee

--Q1
/*
Write the select to :
1. retrieve the server name from the server global, label the column ' erver'
2. retrieve the version - use function to extract the substring as shown, label as 'Version'
3. retrieve the error count from the server global, label the column 'Errors'
4. retrieve the connections from the server global, label the column 'Connections'
5. generate the percentage ratio of packets received vs sent, label the column 'Rcvd %'
** ize your server length to 12
** T- QL operations on integral types operate like c# with truncation, so defne your expression
appropriately.
*/

Declare @Name as char(12) = @@ServerName

Select 
convert(varchar(12),@Name,106) as 'Server', 
substring(@@VERSION, 15,21) as 'Version',
@@ERROR as 'Errors', 
@@CONNECTIONS as 'Connections', 
convert(varchar,convert(int,convert(Float,@@PACK_RECEIVED) / @@PACK_SENT * 100)) + '%' as 'Rcvd%'	

--Q2
/*
Declare and initialize startdate as a datetime to October 31 2000.
Declare and initialize a datetime to 123456789 minutes prior to the above startdate
Write the select to :
1. output startdate in the form : October 31 2000, label the column ' tart'.
2. output the pastdate variable, label the column 'Wayback'
Use CA T and CONVERT once each for required conversions.
Use DATENAME and DATEPART once each as required.
** Note you will have to specify the appropriate length for your conversions, ie. How many digits is
needed to display the year ?
*/

Declare @startdate as datetime = '2000-10-31'
Declare @beforedate as int = -123456789

select 

DateName(month, @startdate) + ' ' + cast(DatePart(Day,@startdate) as varchar(2)) + ' ' 
	+ cast(DatePart(Year,@startdate) as varchar(4)) as 'Start',
Convert(varchar ,dateadd(MINUTE,@beforedate,@startdate), 120) as Wayback


--Q3
/*
Write the select to :
1. generate the number of days between now ( or whatever day this is run ) and Christmas of
this year, label the column 'Days'.
2. output the date of Christmas from your initialized datetime Christmas variable.
You will require a number of variables. Use GetDate() to determine “now”, saving it for use in
building your Christmas date.
*/

declare @nowDate as DateTime = GetDate()
declare @christ as DateTime = 'December 25 2019'

select
	DATEDIFF(Day,@nowDate,@christ) as 'Days', 
	CONVERT(varchar,@christ,104) as 'Xmas'

--Q4
/*
Declare and populate 2 variables, initialized using getdate(), one with the month number ( ie. 8 ),
one with the month name ( ie. October ). - use datename and datepart for this.
Declare and then set using an if/else statement whether the month number is between May and
August inclusive, use ' ummer' and 'Winter'.
Declare and then set using an if/else statement whether the month name has a 'p' in it. use 'Yup'
and 'Nope',
Write a select to :
1. retrieve the name and month number in parenthesis, label the column as shown, use the
form: MonthName(MonthNum), ie. June(6)
2. retrieve your determination of the season, label the column as shown.
3. retrieve your determination of 'p' existence, label the column as shown
** Use a length of 24 for your month name variable, convert to an appropriate size when displaying
the month number ie. What are the most number of months ?
*/

declare @mNumber as int = datePart(month,GetDate())
declare @mName as varchar(24) = datename(month,GetDate())
declare @season as varchar(6)
declare @yesNO as varchar(4)

if @mNumber < 4 or @mNumber > 8
begin
	set @season = 'Winter'
end
else
	set @season = 'Summer'

if CHARINDEX('p',@mName) <> 0
	set @yesNO = 'Yup'
else
	set @yesNo = 'Nope'
select
	convert(varchar(12),@mName) + '(' + convert(varchar(12),@mNumber) + ')' as 'Name(#)',
	@season as 'Season', @yesNO as 'Gotta P'
