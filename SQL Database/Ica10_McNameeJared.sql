--Q1

select
s.CompanyName as 'Company Name',
p.ProductName as 'Product Name',
p.UnitPrice as 'Unit Price'
from Suppliers s
Left outer join Products p
on s.SupplierID = p.SupplierID
order by s.CompanyName, p.ProductName

go

--Q2

select
s.CompanyName as 'Company Name',
p.ProductName as 'Product Name',
p.UnitPrice as 'Unit Price'
from Suppliers s
Left outer join Products p
on s.SupplierID = p.SupplierID
where p.ProductName is null
order by s.CompanyName, p.ProductName

go

--Q3

select
CONCAT(e.LastName, ', ',e.FirstName) as 'Name',
o.OrderDate as 'Order Date'
from Employees e
Left outer join Orders o
on e.EmployeeID = o.EmployeeID
where o.OrderDate is null

go

--Q4

select top 5
p.ProductName as 'Product Name',
od.Quantity as 'Quantity'
from Products p
Left outer join [Order Details] od
on p.ProductID = od.ProductID
order by od.Quantity 

go

--Q5

select top 10
s.CompanyName as 'Company',
p.ProductName as 'Product',
od.Quantity as 'Quantity'
from Suppliers s
left outer join Products p 
on s.SupplierID = p.SupplierID
left outer join [Order Details] od
on p.ProductID = od.ProductID
order by od.Quantity , s.CompanyName desc

go

--Q6

	select c.CompanyName as 'Customer/Supplier with Nothing'
	from Customers c
	left join Orders o
	on c.CustomerID = o.CustomerID
	where o.OrderDate is null
union
	select s.CompanyName
	from Suppliers s
	left join Products p
	on p.SupplierID = s.SupplierID
	where p.ProductName is null
order by 1

go	

--Q7

	select 'Customer' as 'Type', 
	c.CompanyName as 'Customer/Supplier with Nothing'
	from Customers c
	left join Orders o
	on c.CustomerID = o.CustomerID
	where o.OrderDate is null
union
	select 'Supplier' as 'Type', 
	s.CompanyName
	from Suppliers s
	left join Products p
	on s.SupplierID = p.SupplierID
	where p.ProductName is null
order by 1,2 desc
go
