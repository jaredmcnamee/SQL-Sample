-- ica16
-- You will need to install a personal version of the ClassTrak database
-- The Full and Refresh scripts are on the Moodle site.
-- Once installed, you can run the refresh script to restore data that may be modified or 
--  deleted in the process of completing this ica.

use  jmcnamee1_ClassTrak

begin transaction
go

-- q1
-- Complete an update to change all classes to have their descriptions be lower case
-- select all classes to verify your update

update jmcnamee1_ClassTrak.dbo.Classes
set class_desc = Lower(class_desc)

select *
from Classes



-- q2
-- Complete an update to change all classes have 'Web' in their 
-- respective course description to be upper case
-- select all classes to verify your selective update
update jmcnamee1_ClassTrak.dbo.Classes
set class_desc = UPPER(class_desc)
from jmcnamee1_ClassTrak.dbo.Classes c
join Courses co on c.course_id = co.course_id
where co.course_desc like '%Web%'

select *
from Classes



-- q3
-- For class_id = 123
-- Update the score of all results which have a real percentage of less than 50
-- The score should be increased by 10% of the max score value, maybe more pass ?
-- Use ica13_06 select statement to verify pre and post update values,
--  put one select before and after your update call.

declare @class_id as int = 123

select
at.ass_type_desc as 'Type',
round(avg(rt.score),2) as 'Raw Avg',
round(avg( (rt.score / rq.max_score)*100),2) as 'Avg', 
count(rt.score) as 'Num'
from jmcnamee1_ClassTrak.dbo.Assignment_type at
join jmcnamee1_ClassTrak.dbo.Requirements rq on at.ass_type_id = rq.ass_type_id
join jmcnamee1_ClassTrak.dbo.Results rt on rq.req_id = rt.req_id
where rq.class_id = @class_id
group by at.ass_type_desc
order by at.ass_type_desc

update jmcnamee1_ClassTrak.dbo.Results
set score = score + (0.1 * rq.max_score)
from jmcnamee1_ClassTrak.dbo.Results r
join jmcnamee1_ClassTrak.dbo.Requirements rq on r.req_id = rq.req_id
where (r.score / rq.max_score)*100 < 50

select
at.ass_type_desc as 'Type',
round(avg(rt.score),2) as 'Raw Avg',
round(avg( (rt.score / rq.max_score)*100),2) as 'Avg', 
count(rt.score) as 'Num'
from jmcnamee1_ClassTrak.dbo.Assignment_type at
join jmcnamee1_ClassTrak.dbo.Requirements rq on at.ass_type_id = rq.ass_type_id
join jmcnamee1_ClassTrak.dbo.Results rt on rq.req_id = rt.req_id
where rq.class_id = @class_id
group by at.ass_type_desc
order by at.ass_type_desc


rollback
go