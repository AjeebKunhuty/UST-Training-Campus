create database salaryDB;
use salaryDB;

create table employee(
empID int primary key,
name varchar(50),
salary decimal(10,2),
AnnualSalary decimal(10,2));

drop table employee;
alter table employee add LastModified datetime;

truncate table employee;

select * from employee;

create table etl_load_log(
tableName varchar(50),
lastLoadTime datetime);

INSERT INTO ETL_Load_Log
VALUES ('employee','1900-01-01')

truncate table etl_load_log;

