----- CREATE TABLE salary_data_49 ------------
----------------------------------------------

CREATE TABLE salary_data_49 
(
    employee_id int, 
    age int,
    gender text, 
    salary int
);


INSERT INTO salary_data_49 (employee_id, age, gender, salary)
VALUES
(325409,25,'Male',100000),
(87132,25,'Female',100000),
(306095,33,'Male',142000),
(62790,36,'Male',162000),
(798982,31,'Male',190000),
(194025,25,'Male',110000),
(834554,26,'Male',110000),
(859617,23,'Male',95000),
(243058,30,'Female',145000),
(905074,24,'Male',100000),
(947460,33,'Male',100000),
(777868,26,'Female',130000),
(55527,27,'Female',125000),
(388950,26,'Male',130000),
(811939,32,'Male',135000),
(291642,23,'Male',90000),
(286584,26,'Male',120000),
(193637,27,'Female',120000),
(533064,35,'Female',120000),
(179957,37,'Male',160000),
(90607,24,'Male',92000),
(414613,25,'Male',135000),
(168005,24,'Male',95000),
(369092,26,'Female',120000),
(616051,25,'Female',90000),
(495876,26,'Male',135000),
(847155,33,'Female',100000),
(883113,31,'Male',195000),
(755865,41,'Female',80000),
(316880,24,'Male',90000),
(359150,27,'Female',110000),
(73103,29,'Female',130000),
(656502,30,'Male',140000),
(495170,33,'Female',95000),
(513705,33,'Male',120000),
(562186,29,'Male',130000),
(560075,25,'Male',115000),
(516646,23,'Male',92000),
(434438,27,'Male',110000),
(804483,25,'Female',110000),
(829157,29,'Female',150000),
(625025,26,'Female',100000),
(755728,33,'Female',90000),
(751793,25,'Male',125000),
(352001,34,'Male',100000),
(355050,29,'Female',120000),
(657704,30,'Male',160000),
(80413,37,'Female',150000),
(996438,28,'Female',65000);


--------- WINDOW FUNCTION --------------------
----------------------------------------------

select employee_id
    ,salary
    ,row_number() over(order by salary desc) salary_rownumber
    ,rank() over(order by salary desc) salary_rank
    ,dense_rank() over(order by salary desc) salary_denserank
from salary_data_49
order by 3


-------- ALTERNATIVE WITH AGGREGATION --------
----------------------------------------------

--- 2nd highest salary 
select max(salary)
from salary_data_49
where salary < (
    select max(salary) 
    from salary_data_49
 )

--- 3rd highest salary 

select max(salary)
from salary_data
where salary < (
    select max(salary) 
    from salary_data 
    where salary < (
        select max(salary) 
         from salary_data_49
    )
 )

--- 4th highest salary 
select max(salary)
from salary_data_49
where salary < (
    select max(salary) 
    from salary_data_49 
    where salary < (
        select max(salary) 
         from salary_data_49
         where salary < (
            select max(salary) 
            from salary_data_49
         )
    )
 )


-- WINDOW FUNCTION MIRRORING with SELF-JOIN --
----------------------------------------------


---- rank()

SELECT 
    o1.employee_id
    ,o1.age
    ,o1.gender
    ,o1.salary
    ,count(o2.salary)+1 rn
FROM salary_data_49 o1
left JOIN salary_data_49 o2
on (o1.salary < o2.salary) 
group by 1,2,3
order by 4


---- dense_rank()

with dist as 
(
    select distinct salary
    from salary_data
)
SELECT 
    o1.employee_id
    ,o1.age
    ,o1.gender
    ,o1.salary
    ,count(o2.salary)+1 rn
FROM salary_data o1
left JOIN dist o2
on (o1.salary < o2.salary) 
group by 1,2,3,4
order by 5

---- row_number()

SELECT 
    o1.employee_id,
    o1.age,
    o1.gender,
    o1.salary,
    count(o2.salary)+1 rn
FROM salary_data_unique o1
left JOIN salary_data_unique o2
on (o1.salary < o2.salary) 
or (o1.salary = o2.salary and o1.employee_id < o2.employee_id)
group by 1,2,3,4
order by 5 