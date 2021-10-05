create database Atlantic_Current_Ltd;

create table Employee (
emp_id int not null auto_increment,
first_name varchar(20) not null,
last_name varchar(20) not null,
birth_date date not null,
sex varchar(1) not null,
salary int not null,
super_id int,
branch_id int not null,
primary key(emp_id)
);

alter table Employee
modify branch_id int;

create table Branch(
branch_id int,
branch_name varchar(40),
manager_id int,
manager_start_date date,
primary key(branch_id),
foreign key(manager_id) references Employee(emp_id) 
on delete set null
);

alter table Employee 
modify branch_id int;

select * from Employee;

alter table Employee
add foreign key(branch_id)
references Branch(branch_id)
on delete set null;

alter table Employee
add foreign key(super_id)
references Employee(emp_id)
on delete set null;

create table client_(
client_id int primary key,
client_name varchar(40),
branch_id int,
foreign key(branch_id) references
Branch(branch_id) on delete set null
);

create table Works_With(
emp_id int,
client_id int,
total_sales int,
primary key(emp_id, client_id),
foreign key(emp_id) references
Employee(emp_id) on delete cascade,
foreign key(client_id) references
client_(client_id) on delete cascade
);

create table Branch_Supplier(
branch_id int,
supplier_name varchar(40),
supply_type varchar(40),
primary key(branch_id, supplier_name),
foreign key(branch_id) references
Branch(branch_id) on delete cascade
);

-- corporate branch
insert into Employee values
(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, null, null);

insert into Branch values
(1, 'Corporate', 100, '2006-02-09');

update Employee set branch_id = 1
where emp_id = 100;

insert into Employee values
(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- scranton branch
insert into Employee values
(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, null, null);

insert into Branch values
(2, 'Scranton', 102, '1992-04-06');

update Employee set branch_id = 2
where emp_id = 102;

update Employee set super_id = 100
where emp_id = 102;

insert into Employee values
(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2),
(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2),
(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- stamford branch
insert into Employee values
(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, null, null);

insert into Branch values
(3, 'Stamford', 106, '1998-02-13');

update Employee set branch_id = 3
where emp_id = 106;

update Employee set super_id = 100
where emp_id = 106;

insert into Employee values
(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3),
(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);

insert into branch values
(4, 'Buffalo', null, null);

-- inserting into Branch Supplier
insert into branch_supplier values
(2, 'Hammer Mill', 'Paper'),
(2, 'Uni-ball', 'Writing Utensils'),
(3, 'Patriot Paper', 'Paper'),
(2, 'J.T. Forms & Labels', 'Custom Forms'),
(3, 'Uni-ball', 'Writing Utensils'),
(3, 'Hammer Mill', 'Paper'),
(3, 'Stamford Labels', 'Custom Forms');

-- inserting into Client table
insert into client_ values 
(400, 'Dunmore Highschool', 2),
(401, 'Lackawana Country', 2),
(402, 'FedEx', 3),
(403, 'John Daly Law, LLC', 3),
(404, 'Scranton Whitepages', 2),
(405, 'Times Newspaper', 3),
(406, 'FedEx', 2);

-- inserting into Works_With table
insert into works_with values
(105, 400, 55000),
(102, 401, 267000),
(108, 402, 22500),
(107, 403, 5000),
(108, 403, 12000),
(105, 404, 33000),
(107, 405, 26000),
(102, 406, 15000),
(105, 406, 130000);

select * from client_;

select * from employee order by salary desc;

select * from employee
order by sex, first_name, last_name;

-- find the first 5 employees

select * from employee
limit 5;

-- find the first first and last name of employees

select first_name, last_name 
from employee;

select first_name as Forename, last_name as Surname
from employee;

-- find out all the different genders 
select distinct sex 
from employee;

-- find the number of employees 
select count(emp_id)
from employee;

select count(super_id)
from employee; 

-- number of female employees born after 1970
select count(emp_id)
from employee
where sex = 'F' and birth_date > '1971-01-01';

-- find the average of all employees salaries
select avg(salary)
from employee;

select avg(salary)
from employee
where sex = 'M';

-- find the sum of all employees salaries
select sum(salary)
from employee;

-- find out how many males and females there are(aggregation)
select count(sex), sex
from employee
group by sex;

-- find the total sales of each salesperson 
select sum(total_sales), emp_id
from works_with
group by emp_id;

-- find total sales of each clients 
select sum(total_sales), client_id
from works_with
group by client_id;

-- find any client's who are LLC
select * from client_
where client_name like '%LLC%'; 

-- find any brach supplier who are in the label business
select * from branch_supplier
where supplier_name like '%label%';

-- find any employee born in october
 select * from employee
 where birth_date like '____-10%';
 
 -- find any clients who are schools
 select * from client_
 where client_name like '%school%';
 
 -- find a list of employee and branch names
select first_name from employee
union select branch_name from branch;

-- find a list of all money spent or earned by the company
select salary as total_income_expenses from employee
union
select total_sales from works_with;

-- find all branches and the names of their managers
select employee.emp_id, employee.first_name, branch.branch_name
from employee 
join branch
on employee.emp_id = branch.manager_id;

-- find names of all employees who have sold over 30,000
-- to a single client
select employee.first_name, employee.last_name
from employee
where employee.emp_id in 
(select works_with.emp_id from works_with
where works_with.total_sales > 30000);

-- find all clients who are handled by the branch that
-- Michael Scott manages  
select client_.client_name
from client_
where client_.branch_id =
(select branch.branch_id 
from branch
where branch.manager_id = 102
limit 1);
 