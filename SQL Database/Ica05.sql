--Q1

select* from Genre

go

--Q2

select CustomerID as 'Customer ID', LastName as 'Last Name', FirstName as 'First Name', Company 
from Customer

go

--Q3

select convert(varchar(18),CustomerID) as 'Customer ID', convert(varchar(18),FirstName) as 'First Name', convert(varchar(18),Country) as 'Country', convert(varchar(18),State) as 'Region'
from Customer
where Fax is null and State is not null

go

--Q4

declare @7min as int = 7 * 60 * 1000
declare @8min as int = 8 * 60 * 1000

select TrackID as 'Track ID', convert(varchar(26),Name) as 'Name', convert(varchar(64),Composer) as 'Written by' 
from Track
where GenreId = 2
and Milliseconds > @7min and Milliseconds < @8min

go


--Q5

select convert(varchar(48),Company) as 'Company Name', LastName as 'Contact', convert(varchar(36),Address) as 'Street Address'
from Customer
where Country IN('Brazil', 'Argentina', 'Peru', 'Colombia', 'Chile', 'Venezuela', 'Ecuador', 'Bolivia', 'Uruguay', 'Paraguay', 'Guyana', 'Surinam', 'French Guiana', 'Aruba', 'Curacao', 'Trinidad and Tobago', 'Falkland Islands', 'Caribbean Netherlands')
and Company is not null

go

--Q6

select TrackID as 'Track ID', convert(varchar(50),Name) as 'Title', Composer
from Track
where 
(Name Like 'Black%' 
or Composer Like '%verd%') 
and GenreID Not In(1,3,5,7,9)

go

--Q7

select TrackID as 'Track ID', convert(time(3),DATEADD(millisecond,Milliseconds,0),114) as Time, cast( / Milliseconds as money) as 'Cost/Minute'
from Track
 