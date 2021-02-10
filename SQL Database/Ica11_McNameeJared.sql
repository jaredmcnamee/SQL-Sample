--Q1

select
CONCAT(e.LastName, ', ', e.FirstName) as 'Name',
COUNT(o.OrderDate) as 'Num Orders'
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
group by e.LastName, e.FirstName
order by 'Num Orders' desc

go

--Q2

select
CONCAT(e.LastName, ', ', e.FirstName) as 'Name',
AVG(o.Freight) as 'Average Freight',
Convert(varchar,max(o.OrderDate),106) as 'Newest Order Date'
from Employees e
join Orders o on e.EmployeeID = o.EmployeeID
group by e.LastName, e.FirstName
order by max(o.OrderDate), e.LastName 

go

--Q3
select
s.CompanyName as 'Supplier',
s.Country as 'Country',
COUNT(p.ProductName) as 'Num Products',
AVG(p.UnitPrice) as 'Avg Price'
from Suppliers s
left join Products p on s.SupplierID = p.SupplierID
where s.CompanyName like '[H,U,R,T]%'
group by s.CompanyName, s.Country
order by 'Num Products' 

go

--Q4

select
s.CompanyName as 'Supplier',
s.Country as 'Country',
coalesce(min(p.UnitPrice), 0) as 'Min Price',
coalesce(max(p.UnitPrice), 0) as 'Max Price'
from Suppliers s
left join Products p on s.SupplierID = p.SupplierID
where s.Country like 'USA'
group by s.CompanyName, s.Country
order by min(p.UnitPrice)

go

--Q5

select
c.CompanyName as 'Customer',
c.City as 'City',
convert(varchar,o.OrderDate,106) as 'Order Date',
Count(od.Quantity) as 'Products in Order'
from Customers c
left join Orders o on o.CustomerID = c.CustomerID
left join [Order Details] od on o.OrderID = od.OrderID
where c.City like 'Walla Walla'
or c.Country like 'Poland'
group by c.CompanyName, c.City, o.OrderDate
order by 'Products in Order'

go

--Q6

select
CONCAT(e.LastName, ', ', e.FirstName) as 'Name',
convert(money,sum(od.Quantity * od.UnitPrice)) as 'Sales Total',
COUNT(od.Quantity) as 'Detail Items'
from Employees e
left join Orders o on e.EmployeeID = o.EmployeeID
left join [Order Details] od on o.OrderID = od.OrderID
group by e.LastName , e.FirstName
order by 'Sales Total' Desc

go