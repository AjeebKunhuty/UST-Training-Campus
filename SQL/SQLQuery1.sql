create database company_db;

use company_db;

create table employees(
emp_id int primary key,
name varchar(50),
department varchar(50),
salary decimal(10,2),
hire_date date
);


select CURRENT_TIMESTAMP;

insert into employees values
(1, 'Ajeeb', 'Data', 30000, '12-02-2026');

select * from employees;


insert into employees values
(2, 'Jeevanantham', 'Data', 30000, '12-02-2026'),
(3, 'Rithul', 'Data', 30000, '12-02-2026'),
(4, 'Aadharsh', 'Data', 30000, '12-02-2026'),
(5, 'Lijaz', 'DevOps', 30000, '12-02-2026'),
(6, 'Rahul', 'IBM', 30000, '12-02-2026');

select upper(name) from employees;

select name, len(name) from employees;

select count(*) from employees;

select avg(salary) from employees;

select sum(salary) from employees;

create table departments(
dept_id int primary key,
name varchar(50),
manager int not null, 
foreign key(manager) references employees(emp_id));

-- drop table departments;

insert into employees values
(7, 'Shiji', 500000, '2025-01-01', 1),
(8, 'Sanjay', 100000, '2025-06-06', 2),
(9, 'Munna', 900000, '2025-12-31', 3);

alter table departments drop column manager;

alter table departments add manager int;
alter table departments add foreign key(manager) references employees(emp_id);

insert into departments values
(1, 'Data'),
(2, 'DevOps'),
(3, 'IBM');

alter table employees add dept_id int;

alter table employees add foreign key(dept_id) references departments(dept_id);

update employees set dept_id = 3 where department = 'IBM';

alter table employees drop column department;

select departments.dept_id, count(*)
from employees join departments
on departments.dept_id = employees.dept_id
group by departments.dept_id;

update departments set manager = 9 where dept_id = 3;

-- Retrieve all records from tables
select * from employees;
select * from departments;

-- Select specific columns with conditions
select e.emp_id, e.name, d.name
from employees e join departments d
on e.dept_id = d.dept_id
where salary > 30000;

-- Using where, order by and limit
select top 3 * from employees
where dept_id = 1
order by name desc;
-- Limit not supported in MS SQL, use TOP in SELECT instead

-- Renaming column in MS SQL
exec sp_rename 'departments.manager', 'hod', 'column';

select round(avg(salary),2) , sum(salary) / count(*) from employees;

create table projects (
proj_id int primary key,
name varchar(50) unique,
manager int not null,
foreign key(manager) references employees(emp_id));

insert into projects values
(1, 'CyberProof', 9);

-- insert into projects values
-- (4, 'CyberProof', 8);

-- insert into projects (proj_id, name) values
-- (3, 'DataAnalysis');

select * from projects;

select count(*) from departments;

insert into employees values
(10, 'Anvin', 30000, '2026-02-12', 1);

select * from departments;

insert into departments values
(11, 'Cafe', 9);

select * from projects;

insert into projects values
(3, 'DataEngine', 7),
(4, 'DataAnalysis', 5),
(5, 'MSApp', 1),
(6, 'Spring', 3),
(7, 'FastAPI', 4),
(8, 'Etherium', 2),
(9, 'Retail', 6),
(10, 'Cloud', 10);

-- Retrieve employees with department names
select e.emp_id, e.name, d.name
from employees e join departments d
on e.dept_id = d.dept_id;

-- List departments with no employees
select d.dept_id, d.name
from departments d left join employees e
on e.dept_id = d.dept_id
group by d.dept_id, d.name
having count(*) - 1 = 0;

alter table employees add project int;
alter table employees add foreign key(project) references projects(proj_id);

update employees set project = emp_id;

update employees set project = 4 where project = 1;

select * from projects;

-- Find employees working on multiple projects
select e.emp_id, e.name, p.name
from employees e join projects p
on e.project = p.proj_id
where project in (select project 
					from employees 
					group by project 
					having count(*) > 1);

-- count employees per department
select d.name, coalesce(employee_count, 0) as employee_count
from departments d left join 
	(select dept_id, count(*) as employee_count
	from employees
	group by dept_id) as ed
on ed.dept_id = d.dept_id;

select * from employees;

-- Find departments with average salary > 65000
select d.dept_id
from departments d join employees e
on d.dept_id = e.dept_id
group by d.dept_id
having avg(e.salary) > 65000;

alter table projects add budget int;

create view budgets as (
	select project as proj, sum(salary) as budg 
	from employees group by project);
select * from budgets;

update projects set budget = budgets.budg from budgets where projects.proj_id = budgets.proj;

select * from projects;
update projects set budget = 0 where budget is null;

alter table projects add dept int;
alter table projects add foreign key(dept) references departments(dept_id);

update projects set dept = emp.dept_id 
from (select e.emp_id, e.dept_id from departments d join employees e on d.dept_id = e.dept_id) as emp 
where projects.manager = emp.emp_id;

-- Calculate total project budget per department
select dept, sum(budget) from projects
group by dept;

update employees set salary = salary /10 where emp_id = 9;

drop view highlyPaid;

-- Create a view for highly paid employees
create view highlyPaid as
( select top 10 * from employees order by salary desc);

select * from highlyPaid;

-- Create a department salary summary view
create view salarySummary as
(select d.name, sum(coalesce(salary, 0)) as total
from departments d left join employees e
on d.dept_id = e.dept_id
group by d.dept_id, d.name);

select * from salarySummary;

