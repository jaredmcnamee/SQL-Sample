--Q1

Select top 1
s.CompanyName as 'Supplier Company Name',
s.Country as 'Country'
from Suppliers s
order by Country 

go

--Q2

Select top 10
s.CompanyName as 'Supplier Company Name',
s.Country as 'Country'
from Suppliers s
where s.Country = 'Australia'
order by Country 

go

--Q3

Select top 10 percent
p.ProductName as 'Product Name',
p.UnitsInStock as 'Units in Stock'
from Products p
order by p.UnitsInStock desc

go

--Q4

Select
c.CompanyName as 'Customer Company Name',
c.Country as 'Country'
from Customers c
where c.CustomerID in(
	  select top (8)
	  o.CustomerID
	  from Orders o
	  order by o.Freight desc)

go

--Q5

select
o.CustomerID as 'CustomerID',
o.OrderID as 'OrderID',
convert(varchar,o.OrderDate,106) as 'Order Date'
from Orders o
where o.OrderID in(
	  select top (3)
	  od.OrderID
	  from [Order Details] od
	  order by od.Quantity desc)

go

--Q6

select
o.CustomerID as 'CustomerID',
o.OrderID as 'OrderID',
convert(varchar,o.OrderDate,106) as 'Order Date'
from Orders o
where o.OrderID in(
	  select top (3) with ties
	  od.OrderID
	  from [Order Details] od
	  order by od.Quantity desc)

go

--Q7

select
s.CompanyName as 'Supplier Company Name',
s.Country as 'Country'
from Suppliers s
where s.SupplierID in(
	  select p.SupplierID
	  from Products p
	  where p.ProductID in(
			select top 1 percent od.ProductID
			from [Order Details] od
			order by od.UnitPrice * od.Quantity desc))
go
			