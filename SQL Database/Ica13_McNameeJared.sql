--Q1

if exists(select * from sysobjects where name = 'ica13_01')
	drop procedure ica13_01
go

create procedure ica13_01
as

select
CONCAT(e.LastName, ', ', e.FirstName) as 'Name',
COUNT(o.OrderDate) as 'Num Orders'
from NorthwindTraders.dbo.Employees e
join NorthwindTraders.dbo.Orders o on e.EmployeeID = o.EmployeeID
group by e.LastName, e.FirstName
order by 'Num Orders' desc

go

exec ica13_01

go

--Q2

if exists(select * from sysobjects where name = 'ica13_02')
	drop procedure ica13_02
go

create procedure ica13_02
as
select
CONCAT(e.LastName, ', ', e.FirstName) as 'Name',
convert(money,sum(od.Quantity * od.UnitPrice)) as 'Sales Total',
COUNT(od.Quantity) as 'Detail Items'
from NorthwindTraders.dbo.Employees e
left join NorthwindTraders.dbo.Orders o on e.EmployeeID = o.EmployeeID
left join NorthwindTraders.dbo.[Order Details] od on o.OrderID = od.OrderID
group by e.LastName , e.FirstName
order by 'Sales Total' Desc
go

exec ica13_02
go

--Q3

if exists(select * from sysobjects where name = 'ica13_03')
	drop procedure ica13_03
go

create procedure ica13_03

@maxPrice money =  null --15.00

as

select
c.CompanyName as 'Company Name',
c.Country as 'Country'
from NorthwindTraders.dbo.Customers c
where c.CustomerID in(
	  select o.CustomerID
	  from NorthwindTraders.dbo.Orders o
	  where o.OrderID in(
			select od.OrderID
			from NorthwindTraders.dbo.[Order Details] od
			where (od.UnitPrice * od.Quantity) < @maxPrice))
order by c.Country

go

exec ica13_03 @maxPrice = 15
go


--Q4

if exists(select * from sysobjects where name = 'ica13_04')
	drop procedure ica13_04
go

create procedure ica13_04
@minPrice money = null,
@categoryName as nvarchar(max) = ''
as

select
p.ProductName 'ProductName'
from NorthwindTraders.dbo.Products p
where exists(
	  select *
	  from NorthwindTraders.dbo.Categories c
	  where c.CategoryID = p.CategoryID
	  and c.CategoryName like @categoryName)
and p.UnitPrice > @minPrice
order by p.CategoryID, p.ProductName asc
go


exec ica13_04 @minPrice = 20.00,@categoryName = N'Confections'

go

--Q5

if exists(select * from sysobjects where name = 'ica13_05')
	drop procedure ica13_05
go

create procedure ica13_05
@minPrice money = null,
@country nvarchar(max) = 'USA'
as

select
s.CompanyName as 'Supplier',
s.Country as 'Country',
coalesce(min(p.UnitPrice), 0) as 'Min Price',
coalesce(max(p.UnitPrice), 0) as 'Max Price'
from NorthwindTraders.dbo.Suppliers s
left join NorthwindTraders.dbo.Products p on s.SupplierID = p.SupplierID
where s.Country like @country
group by s.CompanyName, s.Country
having min(p.UnitPrice) > @minPrice
order by min(p.UnitPrice)

go

exec ica13_05 15
go

exec ica13_05 @minPrice = 15
go

exec ica13_05 @minPrice = 5, @country = 'Uk'
go

--Q6

if exists(select * from sysobjects where name = 'ica13_06')
	drop procedure ica13_06
go

create procedure ica13_06
@class_id as int = 0
as

select
at.ass_type_desc as 'Type',
round(avg(rt.score),2) as 'Raw Avg',
round(avg( (rt.score / rq.max_score)*100),2) as 'Avg', 
count(rt.score) as 'Num'
from ClassTrak.dbo.Assignment_type at
join ClassTrak.dbo.Requirements rq on at.ass_type_id = rq.ass_type_id
join ClassTrak.dbo.Results rt on rq.req_id = rt.req_id
where rq.class_id = @class_id
group by at.ass_type_desc
order by at.ass_type_desc

go

exec ica13_06 88
go

exec ica13_06 @class_id = 89
go

--Q7

if exists(select * from sysobjects where name = 'ica13_07')
	drop procedure ica13_07
go

create procedure ica13_07
@year int,
@maxAvg int = 50,
@minSize int = 10
as 

select
CONCAT(s.last_name , ', ', s.first_name) as 'Student',
c.class_desc as 'Class',
at.ass_type_desc as 'Type',
COUNT(r.score) as 'Submitted',
ROUND(AVG((r.score/ rq.max_score) *100),1) as 'Avg'
from ClassTrak.dbo.Students s
join ClassTrak.dbo.Results r on s.student_id = r.student_id
join ClassTrak.dbo.Classes c on r.class_id = c.class_id
join ClassTrak.dbo.Requirements rq on r.req_id = rq.req_id
join ClassTrak.dbo.Assignment_type at on rq.ass_type_id = at.ass_type_id
where DATEPART(year, c.start_date) = @year
and r.score is not null
group by s.last_name, s.first_name, c.class_desc , at.ass_type_desc
having COUNT(r.score) > @minSize
and ROUND(AVG((r.score/ rq.max_score) *100),1) < @maxAvg
order by COUNT(r.score),ROUND(AVG((r.score/ rq.max_score) *100),1)

go

exec ica13_07 @year = 2011
go

exec ica13_07 @year = 2011, @maxAvg = 40, @minSize = 15
go