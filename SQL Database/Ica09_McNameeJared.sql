--Q1
declare @USA as varchar(3) = 'USA'

select s.CompanyName as 'Company Name' , p.ProductName as 'Product Name', p.UnitPrice as 'Unit Price'
from Products p
Join  Suppliers s on p.SupplierID = s.SupplierID
where s.Country = @USA
order by s.CompanyName, p.Productname
go

--Q2

declare @UL as varchar(2) = 'ul'

select 
e.LastName + ', ' + e.FirstName as 'Name', t.TerritoryDescription as 'Territory Description'
from Employees e
join EmployeeTerritories et on e.EmployeeID = et.EmployeeID
join Territories t on et.TerritoryID = t.TerritoryID
where e.LastName like '%' + @UL + '%'
order by t.TerritoryDescription

go

--Q3

declare @Sweden varchar(6) = 'Sweden'

select distinct
c.CustomerID as 'Customer ID',
p.ProductName as 'Product Name'
from Customers c
join Orders o on c.CustomerID = o.CustomerID
join [Order Details] od on o.OrderID = od.OrderID
join Products p on p.ProductID = od.ProductID
where c.Country = @Sweden
and p.ProductName like '[U-Z]%'
order by p.ProductName

go

--Q4

declare @selling money = 69.00

select distinct
c.CategoryName as 'Category Name',
p.UnitPrice as 'Product Price',
od.UnitPrice as 'Selling Price'
from Categories c
join Products p on c.CategoryID = p.CategoryID
join [Order Details] od on p.ProductID = od.ProductID
where p.UnitPrice != od.UnitPrice
and od.UnitPrice > @selling
order by od.UnitPrice

go

--Q5
declare @daysAfter int = 34

select
o.ShipName as 'Shipper',
p.ProductName as 'Product Name'
from Orders o
join [Order Details] od on o.OrderID = od.OrderID
join Products p on od.ProductID = p.ProductID
where p.Discontinued = '1'
and DATEdiff(day, o.ShippedDate, o.RequiredDate) > @daysAfter
order by o.ShipName

go