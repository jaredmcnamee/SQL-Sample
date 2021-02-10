--Q1

declare @lower as money = 1.69
declare @upper as money = 1.89

select convert(varchar(24),t.Name) as 'Name', t.UnitPrice as 'Unit Price'
from Track t
where GenreId in(13,25)
and UnitPrice between @lower and @upper
order by t.Name

go


--Q2

declare @lower as money = 16.00
declare @upper as money = 18.00

select IL.InvoiceId as 'Invoice Id', IL.TrackId as 'Track Id', IL.UnitPrice * convert(money,IL.Quantity) as 'Value'
from InvoiceLine IL
where (IL.UnitPrice * CONVERT(money,IL.Quantity)) between @lower and @upper
order by (IL.UnitPrice * CONVERT(money,IL.Quantity)) desc

go

--Q3

declare @black as varchar(5) = 'black'
declare @white as varchar(5) = 'white'

select convert(varchar(48),t.Name) as 'Name', 
convert(varchar(12), t.Composer) as 'Composer', 
t.UnitPrice as 'Unit Price'
from track t
where t.Name like '% ' + @black + ' %'
or t.Name like '%' + @white +'%'
order by t.Name

go

--Q4
declare @cLower as money = 12.00
declare @cUpper as money = 14.00
declare @iLower as int = 200
declare @iUpper as int = 300

select 
CONCAT(convert(varchar(6),IL.InvoiceId),':',convert(varchar(6),IL.TrackId)) as 'Inv:Track',
IL.UnitPrice as 'Unit Price',
IL.Quantity as 'Quantity',
IL.UnitPrice * IL.Quantity as 'Cost'
from InvoiceLine IL
where (IL.UnitPrice * IL.Quantity between @cLower and @cUpper)
and IL.InvoiceId between @iLower and @iUpper
order by IL.InvoiceId, IL.TrackId desc

go

--Q5

select
convert(varchar(24),c.FirstName) as 'First Name',
c.PostalCode as 'PC',
c.Phone as 'Phone',
convert(varchar(24),c.Email) as 'Email'
from Customer c
where c.PostalCode like '[A-Z][0-9][A-Z]_[0-9][A-Z][0-9]'
or c.Phone like '%[0-2][0-2][0-2][0-2]%'
order by c.FirstName
go

--Q6
select
e.LastName as 'LastName',
Convert(int,DATEDIFF(YEAR,e.BirthDate, GETDATE()) + DATEDIFF(YEAR,e.HireDate,GETDATE())) as 'Magic Number',
CASE
	when Convert(int,DATEDIFF(YEAR,e.BirthDate, GETDATE()) + DATEDIFF(YEAR,e.HireDate,GETDATE())) >= 85 then 'Yup'
	else cast(85 - Convert(int,DATEDIFF(YEAR,e.BirthDate, GETDATE()) + DATEDIFF(YEAR,e.HireDate,GETDATE()))as varchar) 
	END as 'Yet ?'
from Employee e
order by Convert(int,DATEDIFF(YEAR,e.BirthDate, GETDATE()) + DATEDIFF(YEAR,e.HireDate,GETDATE()))


go

--Q7

select
c.LastName as 'Last Name',
c.City as 'City',
c.Country as 'Country'
from Customer c
where (c.Country not like '%a'
and c.Country not like '%e'
and c.Country not like '%m'
and c.Country not like '%y')
and c.Company is not null
order by c.Country ,c.City desc,c.LastName desc

go

--Q8
select
distinct c.Country as 'Country'
from Customer c
where c.Country like '[A-F]%'
order by c.Country desc

go

--Q9
declare @why as int = 3

select 
distinct SUBSTRING(t.Name,0,CHARINDEX(' ',t.Name, 0)) as 'First Word'
from Track t
where t.GenreId in('1')
and t.Name like '[aeiou]__%'
and len(SUBSTRING(t.Name,0,CHARINDEX(' ',t.Name, 0))) > @why
order by SUBSTRING(t.Name,0,CHARINDEX(' ',t.Name, 0))

go