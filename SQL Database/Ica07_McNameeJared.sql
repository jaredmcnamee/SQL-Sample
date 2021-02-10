--Q1

declare @freight as int = 800

select
e.LastName as 'Last Name',
e.Title as 'Title'
from Employees e
where e.EmployeeID in (
	  select o.EmployeeID
	  from Orders o
	  where o.Freight > @freight)
order by e.LastName
go

--Q2
declare @freight as int = 800

select
e.LastName as 'Last Name',
e.Title as 'Title'
from Employees e
where exists(
	  select *
	  from Orders o
	  where o.EmployeeID = e.EmployeeID
	  and o.Freight > @freight)
order by e.LastName
go

--Q3

select
p.ProductName as 'Product Name',
p.UnitPrice as 'Unit Price'
from Products p
where p.SupplierID in(
	  select s.SupplierID
	  from Suppliers s
	  where s.Country in('Sweden','Italy'))
order by p.UnitPrice
go

--Q4
select
p.ProductName as 'Product Name',
p.UnitPrice as 'Unit Price'
from Products p
where exists(
	  select *
	  from Suppliers s
	  where s.SupplierID = p.SupplierID
	  and s.Country in('Sweden','Italy'))
order by p.UnitPrice
go

--Q5
declare @minPrice money = 20.00

select
p.ProductName 'ProductName'
from Products p
where p.CategoryID in(
	  select c.CategoryID
	  from Categories c
	  where c.CategoryName in('Confections','Seafood'))
and p.UnitPrice > @minPrice
order by p.CategoryID,p.ProductName
go

--Q6

declare @minPrice money = 20.00

select
p.ProductName 'ProductName'
from Products p
where exists(
	  select *
	  from Categories c
	  where c.CategoryID = p.CategoryID
	  and c.CategoryName in('Confections','Seafood'))
and p.UnitPrice > @minPrice
order by p.CategoryID, p.ProductName
go

--Q7

declare @maxPrice money = 15.00

select
c.CompanyName as 'Company Name',
c.Country as 'Country'
from Customers c
where c.CustomerID in(
	  select o.CustomerID
	  from Orders o
	  where o.OrderID in(
			select od.OrderID
			from [Order Details] od
			where (od.UnitPrice * od.Quantity) < @maxPrice))
order by c.Country

go

--Q8

declare @maxPrice money = 15.00

select
c.CompanyName as 'Company Name',
c.Country as 'Country'
from Customers c
where exists(
	  select *
	  from Orders o
	  where o.CustomerID = c.CustomerID
	  and exists(
		  select *
		  from [Order Details] od
		  where od.OrderID = o.OrderID
		  and (od.UnitPrice * od.Quantity) < @maxPrice))
order by c.Country

go

--Q9

declare @seven as int = 7

select 
p.ProductName
from Products p
where p.ProductID in(
	  select od.ProductID
	  from [Order Details] od
	  where od.OrderID in(
		    select o.OrderID
			from Orders o
			where o.CustomerID in(
				  select c.CustomerID
				  from Customers c
				  where c.Country in('Uk','USA'))
			and DATEDIFF(day,o.RequiredDate, o.ShippedDate) > @seven))
order by p.ProductName

go

--Q10

select
o.OrderID as 'Order Id',
o.ShipCity as 'ShipCity'
from Orders o
where o.OrderID in(
	  select od.OrderID
	  from [Order Details] od
	  where od.ProductID in(
			select p.ProductID
			from Products p
			where p.SupplierID in(
				  select s.SupplierID
				  from Suppliers s
				  where s.City = o.ShipCity)))
order by o.ShipCity
go
