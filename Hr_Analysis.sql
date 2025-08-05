use hr;
#1 Who has been with their current manager the highest?

select EmployeeID, YearsWithCurrManager
from hr_2
order by YearsWithCurrManager desc
limit 10;

#2  Highest earning employees in each department

SELECT main.Department, main.EmployeeNumber, main.MonthlyIncome
FROM (
    SELECT h1.Department, h1.EmployeeNumber, h2.MonthlyIncome
    FROM hr_1 h1
    INNER JOIN hr_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
) AS main
INNER JOIN (
    SELECT h1_inner.Department, MAX(h2_inner.MonthlyIncome) AS max_income
    FROM hr_1 h1_inner
    INNER JOIN hr_2 h2_inner ON h1_inner.EmployeeNumber = h2_inner.EmployeeID
    GROUP BY h1_inner.Department
) AS dept_max
ON main.Department = dept_max.Department AND main.MonthlyIncome = dept_max.max_income;


#3 Employees with longest tenure

SELECT h1.EmployeeNumber, h1.Department, h2.YearsAtCompany
FROM hr_1 h1
INNER JOIN hr_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
WHERE h2.YearsAtCompany = (
    SELECT MAX(YearsAtCompany) FROM hr_2
);

#4 Departments with highest attrition rate

select a.Department, 
count( case
when a.Attrition = 'Yes' then 1 end) as Attrition_Count,
count(*) as Total_Employees,
round(count(case when a.Attrition = 'Yes' then 1 end)/ count(*) * 100, 2) as Attrition_Rate
from hr_1 a
group by a.Department
order by Attrition_Rate desc;

#5 Average distnace from home by department

select Department, avg(DistanceFromHome) as Avg_Dis
from hr_1
group by Department order by Avg_Dis desc;

#6 Employees with highest salary hikes

 select a.EmployeeNumber, a.Department, b.PercentSalaryHike
 from hr_1 a
 inner join hr_2 b on a.EmployeeNumber = b.EmployeeID
 order by b.PercentSalaryHike desc limit 10;
 
 
#7 Log whenever someone gets inserted

create table Employee_Insert 
( Log_Id int auto_increment primary key,
Employee_Number Int,
Insert_Adt timestamp default Current_Timestamp );

create trigger log_employee_insert
after insert on hr_1
for each row
insert into Employee_Insert (EmployeeNumber) Values (New.EmployeeNumber);


#8 Employees with low satisfaction

drop view LowSatisfactionEmployees;
create view LowSatisfactionEmployees as 
select a.EmployeeNumber , a.Department ,
concat(a.JobSatisfaction , ',' , case a.JobSatisfaction
when 1 Then ' Low'
when 2 then ' Medium'
When 3 then ' High'
when 4 then ' Very High'
end)
as JobSatisfactionLabel,
concat(a.EnvironmentSatisfaction, ',' , case a.EnvironmentSatisfaction
when 1 then ' Low'
when 2 then ' Medium'
when 3 then ' High'
when 4 then ' Very High'
end ) as EnvironmentSatisfactionLabel
from hr_1 a
where a.JobSatisfaction <=2 or a.EnvironmentSatisfaction <=2;

select * 
from LowSatisfactionEmployees;

#9  Find youngest employees

SELECT h1.EmployeeNumber, h1.Department, h2.TotalWorkingYears
FROM hr_1 h1
INNER JOIN hr_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
ORDER BY h2.TotalWorkingYears ASC
LIMIT 10;

#10 Employees with highest hourly rate

SELECT EmployeeNumber, Department, HourlyRate
FROM hr_1
ORDER BY HourlyRate DESC
LIMIT 10;

#11 Count of employees per marital status

select MaritalStatus, count(*) as Count
from hr_1
group by MaritalStatus
order by Count Desc;

#12 Employee Count from eavh department

SELECT 
    EducationField,
    COUNT(*) AS EmployeeCount
FROM hr_1
GROUP BY EducationField
ORDER BY EmployeeCount desc ;

#13 


