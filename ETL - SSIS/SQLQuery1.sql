use destinationEmployeeDB;

create table employee (
emp_id int primary key,
emp_name varchar(100),
gender varchar(10),
dept_id int,
role_id int,
location_id int,
join_date date,
status varchar(20));

select * from employee;

truncate table employee;

create table femaleEmployee (
emp_id int primary key,
emp_name varchar(100),
gender varchar(10),
dept_id int,
role_id int,
location_id int,
join_date date,
status varchar(20));

select * from femaleEmployee;


create table employeeWithSalary(
empid int primary key,
name varchar(50),
salary decimal(10,2));

BULK INSERT destinationEmployeeDB.dbo.employeeWithSalary
FROM 'C:\SQL-Data\TextFile1.csv'
WITH (FIRSTROW = 2,
FIELDTERMINATOR = ',',
ROWTERMINATOR='\n' );

update employeeWithSalary set LastModified = SYSDATETIME();

alter table employeeWithSalary drop column LastModified;
alter table employeeWithSalary add LastModified datetime;

select * from employeeWithSalary;

insert into employeeWithSalary values(104, 'Nvidia', 30000.00, SYSDATETIME());