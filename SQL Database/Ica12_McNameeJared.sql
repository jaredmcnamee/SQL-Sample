--Q1
declare @classID as int = 88

select
at.ass_type_desc as 'Type',
avg(rt.score) as 'Raw Avg',
avg( (rt.score / rq.max_score) *100) as 'Avg', 
count(rt.score) as 'Num'
from Assignment_type at
join Requirements rq on at.ass_type_id = rq.ass_type_id
join Results rt on rq.req_id = rt.req_id
where rq.class_id = @classID
group by at.ass_type_desc
order by at.ass_type_desc

go

--Q2
declare @classID as int = 88

select
CONCAT(rq.ass_desc, '(',at.ass_type_desc,')') as 'Desc(Type)',
round(avg((rt.score / rq.max_score) *100),2) as 'Avg',
count(rt.score) as 'Num Score'
from Assignment_type at
join Requirements rq on at.ass_type_id = rq.ass_type_id
join Results rt on rq.req_id = rt.req_id
where rq.class_id = @classID
group by at.ass_type_desc, rq.ass_desc
having round(avg( (rt.score / rq.max_score) *100),2) > 57
order by  rq.ass_desc, at.ass_type_desc

go

--Q3
declare @classID as int = 123

select
s.last_name as 'Last',
at.ass_type_desc as 'ass_type_desc',
round(Min( (rt.score / rq.max_score) *100),1) as 'Low',
round(Max( (rt.score / rq.max_score) *100),1) as 'High',
round(avg( (rt.score / rq.max_score) *100),1) as 'Avg'
from Students s
join Results rt on s.student_id = rt.student_id
join Requirements rq on rt.req_id = rq.req_id
join Assignment_type at on rq.ass_type_id = at.ass_type_id
where rq.class_id = @classID
group by s.last_name, at.ass_type_desc
having round(avg( (rt.score / rq.max_score) *100),1) > 70
order by at.ass_type_desc, 'Avg'

go

--Q4

select
i.last_name as 'Instructor',
convert(varchar, c.start_date, 106) as 'Start',
count(cs.active) as 'Num Registered',
sum(convert(int,cs.active)) as 'Num Active'
from Instructors i
join Classes c on i.instructor_id = c.instructor_id
join class_to_student cs on c.class_id = cs.class_id
group by i.last_name , convert(varchar, c.start_date, 106)
having convert(int,count(cs.active) - sum(convert(int,cs.active))) > 3
order by i.last_name, convert(varchar, c.start_date, 106)

go

--Q5
declare @start int = 2011
declare @avg int = 40

select
CONCAT(s.last_name , ', ', s.first_name) as 'Student',
c.class_desc as 'Class',
at.ass_type_desc as 'Type',
COUNT(r.score) as 'Submitted',
ROUND(AVG((r.score/ rq.max_score) *100),1) as 'Avg'
from Students s
join Results r on s.student_id = r.student_id
join Classes c on r.class_id = c.class_id
join Requirements rq on r.req_id = rq.req_id
join Assignment_type at on rq.ass_type_id = at.ass_type_id
where DATEPART(year, c.start_date) = @start
and r.score is not null
group by s.last_name, s.first_name, c.class_desc , at.ass_type_desc
having COUNT(r.score) > 10
and ROUND(AVG((r.score/ rq.max_score) *100),1) < 40
order by COUNT(r.score),ROUND(AVG((r.score/ rq.max_score) *100),1)

go