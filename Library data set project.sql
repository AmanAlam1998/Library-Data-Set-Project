
drop table if exists branch;

create table branch(
branch_id varchar(20) primary key,
manager_id varchar(20),
branch_address varchar(100),
contact_no varchar(50)
);
drop table if exists employee;
create table employee(emp_id varchar(50) primary key,
emp_name varchar(50),
position varchar(50),
salary numeric(10,2),
branch_id varchar(50)
);


drop table if exists members;
create table members 
(
member_id varchar(50) primary key,
member_name varchar(50),
member_address varchar(50),
reg_date date
);

drop table if exists books;
create table books
(
isbn varchar(50) primary key,
book_title varchar(100),
category varchar(50),
rental_price float,
status varchar(50),
author varchar(50),
publisher varchar(50)
);


drop table if exists return_status;
create table return_status
(
return_id varchar(50) primary key,
issued_id varchar(50),
return_book_name varchar(50),
return_date date,
return_book_isbn varchar(50)
);

drop table if exists issued_status;
create table issued_status(
issued_id varchar(50) primary key,
issued_member_id varchar(50),
issued_book_name varchar(50),
issued_date date,
issued_book_isbn varchar(50),
issued_emp_id varchar(50)
);


--Adding foreign keys--

alter table issued_status
add constraint fk_members
foreign key (issued_member_id)
references members(member_id);

alter table return_status
add constraint fk_issued
foreign key (issued_id)
references issued_status(issued_id);

alter table issued_status
add constraint fk_books
foreign key (issued_book_isbn)
references books(isbn);

alter table issued_status
add constraint fk_employees
foreign key(issued_emp_id)
references employee(emp_id);

alter table employee
add constraint fk_branch
foreign key(branch_id)
references branch(branch_id);

alter table books
alter column book_title type varchar(200);


alter table issued_status
alter column issued_book_name type varchar(200);


select * from branch;
select * from employee;
select * from members;
select * from books;
select * from return_status;
select * from issued_status;



