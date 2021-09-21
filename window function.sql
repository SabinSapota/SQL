
-- partition function 
select* ,
avg(Salary) over(partition by Gender) as avgsalary,
count(Gender) over (partition by Gender) as GenderTotal,
max(Salary) over (partition by Gender) as MaxSalary,
min(Salary) over (partition by Gender) as Minsalary
from Employees;

--rank and dense rank
--rank function skips rankings if there is tie where as dense rank will not

select Name,Gender,Salary,
rank() over(order by Salary DESC) as [rank],
DENSE_RANK() over(order by Salary DESC) as [denserank]
from Employees;

--Now lets uses the partition cluase which is optional
select Name,Gender,Salary,
rank() over(partition by Gender order by Salary DESC) as [rank],
DENSE_RANK() over(partition by Gender order by Salary DESC) as [denserank]
from Employees;

--top N salary, you can use both dense rank and rank according to your needs
with result
as
(
select*,
DENSE_RANK() over(order by salary DESC) as salaryrank
from Employees
)
select top 1  salary from result where salaryrank=5;

select* from Employees order by Salary DESC;

--window function

select*,
avg(salary) over(partition by Gender order by salary rows between unbounded preceding and unbounded following) as avgsalary,
sum(salary) over(partition by Gender order by salary rows between unbounded preceding and unbounded following) as [sum],
count(salary) over(partition by Gender order by salary rows between unbounded preceding and unbounded following) as [count]
from Employees;

--1 row before and after
select*,
avg(salary) over(partition by Gender order by salary rows between 1 preceding and 1 following) as avgsalary,
sum(salary) over(partition by Gender order by salary rows between 1 preceding and 1 following) as [sum],
count(salary) over(partition by Gender order by salary rows between 1 preceding and 1 following) as [count]
from Employees;
--difference between rows and range
--rows treat duplicates as distinct values where as Range treats them as a single  entity
select* ,--running total
sum(Salary) over( order by Salary rows between unbounded preceding and current row) as runningTotal
from Employees;

select* ,--running total
sum(Salary) over( order by Salary range between unbounded preceding and current row) as runningTotal
from Employees;

--lead and lag function
--lead function is used to access subsequent row data along with current row data
--lag function is used to access previous row data along with current row data

select*,
lead(Salary,1,-1) over(partition by Gender order by Salary) as [lead],
lag(Salary) over (partition by Gender order by Salary) as [lag]
from Employees;

--last value function
--it retrieves last value from specified column
select*,
LAST_VALUE(Name) over(partition by Gender order by Salary rows between unbounded preceding and unbounded following)
from Employees;

--row number returns the sequential number of a row starting at 1
-- when the data is partitioned, row number is reset to 1 when the partition changes
--we can use this function to remove the duplicates
select* ,
row_number() over(partition by Gender order by Gender) as [row_number]
from master.dbo.Employees;

--removing duplicates rows with row_number

with employeecte as
(select*, row_number() over(partition by ID order by ID) as [row_number]
from Employees
)

delete from  employeecte where [row_number]>1



-----------------------------------------------------------------------------------
--finding n highest salary  using subquary

select* from Employees  order by Salary desc;

select top 1 Salary from (
select  distinct top 4 Salary from Employees
order by Salary desc)
result order by Salary;

--using dense rank function to find n highest salary
 with result as
 (
 select*, DENSE_RANK() 
over(order by Salary DESC) as rank1 
 from practice.dbo.Employees
 )
 select top 1 Salary from result where rank1=6;


 



