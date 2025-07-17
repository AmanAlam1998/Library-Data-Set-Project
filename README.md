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
SELECT * from books;
select * from branch;
select * from employee;
select * from return_status;
select * from issued_status;
select * from members;


insert into books(isbn,book_title,category,rental_price,status,author,publisher) values

('978-1-60129-456-2','To Kill a Mocking Bird','Classic',6.00,'yes','Harper Lee','j.b.Lippincott & Co.');

select * from books
where book_title='To Kill a Mocking Bird';


select * from books;

select * from members;

select * from issued_status;
select * from employee;


update members
set member_address= '125 Main St'
where member_id='C101';


select * from members
where member_id='C101';
select * from issued_status;
delete from issued_status
where issued_id='IS121';

Select issued_id from return_status;

select * from issued_status
where issued_id='IS121';


select * from issued_status
where issued_emp_id='E101';

select issued_emp_id, count(issued_id) as total_books_issued
from issued_status
group by issued_emp_id;


select issued_emp_id
from issued_status
group by issued_emp_id
having count(issued_id)>1;


create table book_counts
as
select b.isbn,b.book_title,
count(i.issued_id) as no_books_issued
from books as b
join
issued_status as i
on i.issued_book_isbn=b.isbn
group by isbn,book_title;

select * from  book_counts;

select * from books
where category='Classic';

select category,book_title,count(distinct(book_title)) as no_category_books
from books
group by category,book_title;

select * from books;

select b.category, sum(b.rental_price) as Total_Price,count(*)as No_books_issued
from books as b
join
issued_status as i
on i.issued_book_isbn=b.isbn
group by category;

select * from members
where reg_date>=current_date-interval '180 days';

select * from branch;
select * from employee;

select e.emp_id,e.emp_name,e.position,e.salary,br.manager_id,br.branch_address,br.manager_id,e1.emp_name as Manager
from branch
as br
join
employee as e
on e.branch_id=br.branch_id
join
employee as e1
on e1.emp_id=br.manager_id
group by e.emp_id,e.emp_name,e.position,e.salary,br.manager_id,br.branch_address,br.manager_id,e1.emp_name
order by emp_id asc;

create table books_price
as
select * from books
where rental_price>7;

select * from books_price;

select * from return_status;

select * from issued_status;

select * from 
issued_status as i
left join 
return_status as r
on
i.issued_id=r.issued_id
where return_id is null;

insert into issued_status(issued_id,issued_member_id,issued_book_name,issued_date,issued_book_isbn,issued_emp_id)
values('IS151','C118','The Cather in the Rye',Current_date-interval '24 days','978-0-553-29698-2','E108'),
('IS152','C119','The Cather in the Rye',Current_date-interval '13 days','978-0-553-29698-2','E109'),
('IS153','C106','Pride and Prejudice',Current_date-interval '7 days','978-0-14-143951-8','E107'),
('IS154','C105','The Road',Current_date-interval '32 days','978-0-375-50167-0','E101');


alter table return_status
add column book_quality varchar(15) default('Good');

select * from return_status;

update return_status
set book_quality='Damaged'
where issued_id in ('IS112','IS117','IS118');

select * from return_status;




select * from books;
select * from issued_status;
select * from return_status;
select * from members;

select i.issued_member_id,
m.member_name,
b.book_title,
i.issued_date,
current_date-i.issued_date as Overdue_Days
from issued_status as i
join
members as m
on i.issued_member_id=m.member_id
join
books as b
on b.isbn=i.issued_book_isbn
join
return_status as r
on r.issued_id=i.issued_id
where r.return_date is null
and (current_date-i.issued_date)>30
order by issued_member_id;

select * from books;
select * from return_status;

drop table if exists return_status;
create table return_status(
return_id varchar(50) primary key,
issued_id varchar(50),
return_book_name varchar(200),
return_date date,
return_book_isbn varchar(60),
 foreign key(issued_id)references issued_status(issued_id),
 foreign key(return_book_isbn) references books(isbn)
);

select * from return_status;


create or replace store procedure add_return_records(p_return_id varchar(20),p_issued_id varchar(20),p_book_qulaity varchar(20))
language plpgsql
as
$$
declare
v_isbn varchar(30);
v_book_name varchar(100);
begin
insert into return_status(return_id,issued_id,return_date,book_qulaity)
values
(p_return_id,p_issued_id,current_date,p_book_qulaity);

select 
issued_book_isbn,
book_title,
into
v_isbn,
v_book_name
from issued_status
where issued_id=issued_id;

update books
set staus='Yes'
where isbn=v_isbn;

raise notice 'Thank You for returning the books: %', v_book_name;
end;
$$
call add_return_records()

--books==issued_status==return_status==emp_id==members==branch

SELECT * from books;
select * from branch;
select * from employee;
select * from return_status;
select * from issued_status;
select * from members;

create table branch_report
as 
select
b.branch_id,
b.manager_id,
sum(bk.rental_price) as total_revenue,
count(i.issued_id) as No_of_books_issued,
count(r.return_status) as No_of_books_return
from
issued_status as i
join
employee as e
on e.emp_id=i.issued_emp_id
join
members as m
on
m.member_id=i.issued_member_id
join
branch as b
on
e.branch_id=b.branch_id
left join
return_status as r
on
r.issued_id=i.issued_id
join
books as bk
on
bk.isbn=i.issued_book_isbn
group by b.branch_id,b.manager_id;


create table active_memebers
as
select * from members
where member_id in(
select  distinct(issued_member_id)
from issued_status
where issued_date >= current_date-interval '2 months'
order by issued_member_id asc
);

select * from employee;
select * from branch;
select * from issued_status;

select e.emp_name,e.branch_id,count(issued_id)as Total_books_issued
from issued_status as i
join
employee as e
on e.emp_id=i.issued_emp_id
group by e.emp_name,e.branch_id
order by Total_books_issued desc
limit 3;


select * from books;
select * from return_status;
select * from issued_status;
