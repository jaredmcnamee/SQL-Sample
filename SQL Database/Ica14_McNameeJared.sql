--Q1

if exists (select * from sysobjects where name like 'ica14_01')
drop procedure ica14_01
go

create procedure ica14_01
@category as varchar(max) = '',
@productName as varchar(max) output,
@quantity as int output
as
select top 1
@productName = p.ProductName,
@quantity = od.Quantity
from NorthwindTraders.dbo.Products p
left join NorthwindTraders.dbo.[Order Details] od
on p.ProductID = od.ProductID
join NorthwindTraders.dbo.Categories c 
on p.CategoryID = c.CategoryID
where c.CategoryName = @category
order by od.Quantity desc

go

declare @PN varchar(20) = ' '
declare @Qu int = 0

execute ica14_01 'beverages',@PN output,@Qu output

select 'Beverages' as 'Category', @PN 'ProductName', @Qu 'Highest Qty'

go

declare @PN varchar(20) = ' '
declare @Qu int = 0

execute ica14_01 'Confections',@PN output,@Qu output

select 'Confections' as 'Category', @PN 'ProductName', @Qu 'Highest Qty'

go

--Q2

if exists (select * from sysobjects where name like 'ica14_02')
drop procedure ica14_02
go

create procedure ica14_02
@year as int = null,
@name as varchar(64) output,
@avFreight as money output
as

select top 1
@name = CONCAT(e.LastName, ', ', e.FirstName),
@avFreight = AVG(o.Freight)
--Convert(varchar,max(o.OrderDate),106) as 'Newest Order Date'
from NorthwindTraders.dbo.Employees e
join NorthwindTraders.dbo.Orders o on e.EmployeeID = o.EmployeeID
where DATEPART(year,o.OrderDate) = @year
group by e.LastName, e.FirstName
order by AVG(o.Freight) desc

go

declare @empName varchar(64) = ''
declare @Freight money = 0

execute ica14_02 1996, @empName output, @Freight output

select '1996' as 'Year', @empName 'Name', @Freight 'Biggest Avg Freight'

execute ica14_02 1997, @empName output, @Freight output

select '1997' as 'Year', @empName 'Name', @Freight 'Biggest Avg Freight'

go

--Q3

if exists (select * from sysobjects where name like 'ica14_03')
drop procedure ica14_03
go

create procedure ica14_03
@class_id int = '',
@ass_type_des varchar(max) = 'all'
as

select 
s.last_name 'Last', 
at.ass_type_desc 'ass_type_desc',  
round(MIN(r.score / rq.max_score * 100),1) 'Low',
round(Max(r.score/ rq.max_score * 100),1) 'High',
round(AVG(r.score/rq.max_score *100),1) 'Avg',
c.class_id 
into #temp
from ClassTrak.dbo.Students s
join ClassTrak.dbo.Results r on s.student_id = r.student_id
join ClassTrak.dbo.Requirements rq on r.req_id = rq.req_id
join ClassTrak.dbo.Assignment_type at on rq.ass_type_id = at.ass_type_id
join ClassTrak.dbo.Classes c on r.class_id = c.class_id
where c.class_id = 123
group by s.last_name, at.ass_type_desc, c.class_id

declare @type varchar(max) = ''
if(@ass_type_des = 'ica')
begin
		set @type = 'Assignment'
end
if(@ass_type_des = 'lab')
begin
		set @type = 'Lab'
end
if(@ass_type_des = 'le')
begin
		set @type = 'Lab Exam'
end
if(@ass_type_des = 'fe')
begin
		set @type = 'Final Exam'
end

		select Last,ica.ass_type_desc,ica.Low, ica.High,ica.Avg
		from #temp ica
		where ica.ass_type_desc = @type
		order by ica.Avg desc
go

declare @cid as int
set @cid = 123
exec ica14_03 @cid, 'ica'
set @cid = 123
exec ica14_03 @cid, 'le'
go

--Q4
if exists (select * from sysobjects where name like 'ica14_04')
drop procedure ica14_04
go

create procedure ica14_04
@student varchar(max) = '',
@summary int = 0
as

declare @id int = 0
declare @first varchar(30) = ''
declare @last varchar(30) = ''
declare @name varchar(max) = ''

select
@id = s.student_id,
@name = left(CONCAT(s.first_name, ' ' , s.last_name),CHARINDEX(' ', CONCAT(s.first_name, ' ' , s.last_name))-1)
from ClassTrak.dbo.Students s
where s.first_name = @student

if(@@ROWCOUNT != 1)
	return -1

select
CONCAT(s.first_name, ' ' , s.last_name) as 'Name',
c.class_desc,
a.ass_type_id,
r.score,
rq.max_score,
s.student_id
into #temp
from ClassTrak.dbo.Students s
join ClassTrak.dbo.Results r on s.student_id = r.student_id
join ClassTrak.dbo.Classes c on r.class_id = c.class_id
join ClassTrak.dbo.Requirements rq on r.req_id = rq.req_id
join ClassTrak.dbo.Assignment_type a on rq.ass_type_id = a.ass_type_id
where s.student_id = @id

if(@summary = 0)
begin
	select
	t.Name,
	t.class_desc,
	t.ass_type_id,
	round(AVG(t.score/t.max_score *100),1) 'Avg'
	from #temp t
	group by t.Name, t.class_desc , t.ass_type_id
	order by t.class_desc
end
if(@summary = 1)
begin
	select
	t.Name,
	t.class_desc,
	round(AVG(t.score/t.max_score *100),1) 'Avg'
	from #temp t
	group by t.Name, t.class_desc
	order by t.class_desc
end


return 1
go

declare @retVal as int
exec @retVal = ica14_04 @student = 'Ro'
select @retVal

exec @retVal = ica14_04 @student = 'Ron'select @retVal

exec @retVal = ica14_04 @student = 'Ron', @summary = 1
select @retVal

go

--Q5

if exists (select * from sysobjects where name like 'ica14_05')
drop procedure ica14_05
go

create procedure ica14_05
@instLast varchar(max) = '',
@name varchar(max) output,
@returned int output,
@numClass int output,
@totalStu int output,
@totalGra int output,
@average  float output
as

declare @id int = 0


select
@id = i.instructor_id,
@name = CONCAT(i.first_name, ' ', i.last_name)
from ClassTrak.dbo.Instructors i
where i.last_name like( @instLast + '%')

set @returned = @@ROWCOUNT

if(@returned != 1)
begin
	set @returned = -1
	return @returned
end



select
@numClass = COUNT(c.class_id)
from ClassTrak.dbo.Instructors i
join ClassTrak.dbo.Classes c on i.instructor_id = c.instructor_id
where i.instructor_id = @id

select
@totalStu = COUNT(cs.active)
from ClassTrak.dbo.Instructors i
join ClassTrak.dbo.Classes c on i.instructor_id = c.instructor_id
join ClassTrak.dbo.class_to_student cs on c.class_id = cs.class_id
where i.instructor_id = @id

select
@totalGra = COUNT(r.score),
@average = AVG(r.score/rq.max_score*100)
from ClassTrak.dbo.Instructors i
join ClassTrak.dbo.Classes c on i.instructor_id = c.instructor_id
join ClassTrak.dbo.Results r on c.class_id = r.class_id
join ClassTrak.dbo.Requirements rq on r.req_id = rq.req_id
where i.instructor_id = @id

return @returned

go

Declare @name     varchar(30)
Declare @returned int 
Declare @numClass int 
Declare @totalStu int 
Declare @totalGra int 
Declare @average  float 

execute ica14_05 'Cas', @name output, @returned output, @numClass output, @totalStu output, @totalGra output, @average output

select @name 'Instructor' , @returned 'Returned' , @numClass 'Num Classes', @totalStu 'Total Student',  @totalGra 'Total Graded', @average 'Avg Awarded' 


