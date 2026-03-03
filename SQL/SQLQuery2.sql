create database employeeAnalytics;
use employeeAnalytics;

-- drop table departments;
create table departments(
	dept_id int primary key,
	dept_name varchar(50) not null
	);

-- drop table locations;
create table locations(
	location_id int primary key,
	location_name varchar(50) not null
);

create table job_roles(
	role_id int primary key,
	role_name varchar(50) not null,
	min_salary decimal(10,2),
	max_salary decimal(10,2)
);

-- drop table employees;

create table employees(
	emp_id int primary key,
	emp_name varchar(100) not null,
	gender varchar(10),
	dept_id int,
	role_id int,
	location_id int,
	join_date date,
	status varchar(20) default 'Active',
	foreign key(dept_id) references departments(dept_id),
	foreign key(role_id) references job_roles(role_id),
	foreign key(location_id) references locations(location_id)
);

create table salaries(
	salary_id int primary key,
	emp_id int,
	salary decimal(10,2),
	effective_date date,
	foreign key(emp_id) references employees(emp_id)
);

create table performance_reviews(
	review_id int primary key,
	emp_id int,
	review_year int,
	rating decimal(2,1) check (rating between 1 and 5),
	foreign key(emp_id) references employees(emp_id)
);

truncate table employees;

BULK INSERT employeeAnalytics.dbo.performance_reviews
FROM 'C:\SQL-Data\Employeeanalytics - Performance_reviews extras.csv'
WITH (FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR='\n' );

select * from performance_reviews order by rating desc;


--Performance analytics

--top 10 high performing employees

select top 10 employees.*, rating from employees 
join performance_reviews on employees.emp_id = performance_reviews.emp_id
order by rating desc;

--average rating per department

select distinct employees.dept_id, avg(rating) over (partition by dept_id order by dept_id desc)
from employees 
join performance_reviews on employees.emp_id = performance_reviews.emp_id;

--employees eligible for promotion(rating > 4 and 2+ years)

select employees.* from employees join performance_reviews on
employees.emp_id = performance_reviews.emp_id
where DATEDIFF(year,join_date,SYSDATETIME()) >= 2 and rating > 4;

--performance trend over years

select review_year, avg(rating) from performance_reviews group by review_year;


--Salary analytics

--salary distribution per department

select departments.dept_id, dept_name, salaryDistribution 
from (select dept_id, sum(salary) as salaryDistribution from salaries join employees on salaries.emp_id = employees.emp_id
group by dept_id) as distribut join departments on departments.dept_id = distribut.dept_id;

--highest and lowest salary per role

select job_roles.role_id, max(salary) as highestSalary, min(salary) as lowestSalary
from job_roles join employees on employees.role_id = job_roles.role_id 
join salaries on employees.emp_id = salaries.emp_id
group by job_roles.role_id;

--salary vs performance correlation

SELECT 
    (COUNT(*) * SUM(salary * rating) - SUM(salary) * SUM(rating)) /
    (SQRT(COUNT(*) * SUM(POWER(salary, 2)) - POWER(SUM(price), 2)) *
     SQRT(COUNT(*) * SUM(POWER(rating, 2)) - POWER(SUM(rating), 2)))
    AS correlation_coefficient
FROM 

--employees below department average salary

select employees.*, averageDeptSalary
from (select dept_id, avg(salary) as averageDeptSalary from salaries join employees on salaries.emp_id = employees.emp_id
group by dept_id) as average join employees on average.dept_id = employees.dept_id 
join salaries on salaries.emp_id = employees.emp_id
where salary < averageDeptSalary;


--Department growth

--hiring trend per year

select year(join_date), count(*) from employees group by year(join_date);

--headcount growth by department

select dept_id, year(join_date) as yearOfJoining, count(*) as empCount 
from employees group by year(join_date), dept_id
order by dept_id, year(join_date);

--attrition rate by department

select departments.dept_id, dept_name, count(*)
from departments join employees on departments.dept_id = employees.dept_id
where employees.status = 'Resigned'
group by departments.dept_id, dept_name;


--Strategic insights

--employee overdue for promotion

select employees.*, rating from employees 
join performance_reviews on employees.emp_id = performance_reviews.emp_id
where datediff(year,join_date, sysdatetime()) > 5
order by rating desc;

--high salary but low performance cases

select employees.*, salary, rating from employees 
join performance_reviews on employees.emp_id = performance_reviews.emp_id
join salaries on salaries.emp_id = employees.emp_id
where rating < 4.0
order by salary desc, rating asc

--most stable department(lowest attrition)

select departments.dept_id, dept_name, count(*)
from departments left join employees on departments.dept_id = employees.dept_id
where employees.status = 'Resigned'
group by departments.dept_id, dept_name
order by count(*) ;

--location-wise salary comparison

select locations.location_id, location_name, sum(salary) 
from employees 
join salaries on employees.emp_id = salaries.emp_id
join locations on locations.location_id = employees.location_id
group by locations.location_id, location_name;

--gender diversity ratio (if added)

select gender, count(*) from employees group by gender;

--median salary calculation

WITH RankedSalaries AS (
    SELECT 
        salary, 
        ROW_NUMBER() OVER (ORDER BY salary) as ranking,
        COUNT(*) OVER () as total_count
    FROM salaries
)
SELECT 
    ROUND(AVG(salary), 2) AS median_salary
FROM RankedSalaries
WHERE ranking IN (FLOOR((total_count + 1) / 2.0), ROUND((total_count + 1) / 2.0, 0));

--identify leadership pipeline candidates

select employees.* from employees join performance_reviews on performance_reviews.emp_id = employees.emp_id
where rating > 4.5;