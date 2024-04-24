
create database online_bank;
use online_bank;
create table CUSTOMERS  (CUSTOMER_ID int null ,CUSTOMER_NAME varchar(50) not null,CUSTOMER_ADDRESS text not null,
CUSTOMER_ACCOUNT_NUMBER varchar(100) ,DATE_OF_BIRTH date not null,CUSTOMER_GENDER enum('MALE','FEMALE'),
CUSTOMER_PAN_NUMBER varchar(50) not null,
CUSTOMER_AADHAR_NUMBER Bigint not null,BANK_NAME varchar(10) not null,CUSTOMER_IFSC_CODE varchar(20) not null,CUSTOMER_EMAIL varchar(30) not null,
CUSTOMER_PHONE_NUMBER bigint not null,CUSTOMER_NATIONALITY enum('INDIAN') not null,
CUSTOMER_ACCOUNT_TYPE enum('CURRENT','SAVING') not null,CUSTOMER_ACCOUNT_STATUS boolean not null, 

constraint CUSTOMER_PK	primary key(CUSTOMER_ACCOUNT_NUMBER) ,
constraint CUSTOMER_UK unique(CUSTOMER_ACCOUNT_NUMBER,CUSTOMER_PAN_NUMBER,
CUSTOMER_AADHAR_NUMBER,CUSTOMER_EMAIL,CUSTOMER_PHONE_NUMBER),
constraint CUSTOMER_CK check(CUSTOMER_NATIONALITY='INDIAN')
);


select *from customers order by CUSTOMER_ID;


drop table customers;

select * from customers;

desc customers;

select customer_address from customers;
select customer_account_status from customers;

-- import statement for excel

LOAD DATA INFILE 'C:/customers.csv'
INTO TABLE CUSTOMERS
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

-- its used for to show the mysql secur file option

select @@global.secure_file_priv;
show variables like'secure_file_priv';


drop table TRANSACTION ;


create table transaction(
	TRANSACTION_ID int auto_increment  ,CUSTOMER_ACCOUNT_NUMBER varchar(30) not null ,
    TRANSACTION_TYPE enum('DEBIT','CREDIT') default null,TRANSACTION_FROM varchar(30) default null,
    TRANSACTION_TO varchar(30) default null,TRANSACTION_DATE date default null,
	TRANSACTION_TIME  time default null ,TRANSACTION_AMOUNT decimal(20,3) default null,
    ACCOUNT_BALANCE decimal(20,3),TRANSACTION_REMARKS text,
    constraint TRANSACTION_PK primary key(TRANSACTION_ID),
    constraint TRANSACTION_FK foreign key(CUSTOMER_ACCOUNT_NUMBER)references customers(CUSTOMER_ACCOUNT_NUMBER)
    -- constraint TRANSACTION_CK check(TRANSACTION_AMOUNT>1000)
);
-- import 
LOAD DATA INFILE 'C:/transaction.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS; 


drop table transaction;


use project_online;

select*from transaction;



-- fixed_ta

create table FIXED_DEPOSIT(
	FD_ID int auto_increment,FD_ACCOUNT_NUMBER varchar(30),FD_PERIOD_YEAR int,
	FD_START_DATE date,FD_END_DATE date,FD_INTREST varchar(10),FD_AMOUNT decimal(20,3),
	constraint FD_PK primary key(FD_ID),
    -- constraint FD_UK unique(FD_ACCOUNT_NUMBER),
    constraint FD_CK check(FD_AMOUNT>50000),
    constraint FD_FK foreign key(FD_ACCOUNT_NUMBER) references customers(CUSTOMER_ACCOUNT_NUMBER)
);

LOAD DATA INFILE
 'C:/fixed.csv'
INTO TABLE FIXED_DEPOSIT
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 


drop table FIXED_DEPOSIT;


select*from fixed_deposit;

select*from customers;
select*from transaction;

-- LOAN TABLE


create table LOAN(
	LOAN_ID int auto_increment not null ,LOAN_ACCOUNT_NUMBER varchar(30) not null,
    LOAN_TENSURE_YEAR int not null,LOAN_START_DATE date not null,
    LOAN_END_DATE date not null,LOAN_INTREST varchar(10) not null,LOAN_TYPE enum("HOME","BUSINESS","PERSONAL") not null,
    LOAN_AMOUNT decimal(20,3) not null,
    LOAN_PAYMENT_DATE date not null,LOAN_PAYMENT_TIME TIME not null,LOAN_NODUE_AMOUNT boolean  not null ,
    constraint LOAN_PK primary key(LOAN_ID),
    constraint LOAN_UK unique(LOAN_ACCOUNT_NUMBER),
    constraint LOANFK foreign key(LOAN_ACCOUNT_NUMBER) references customers(CUSTOMER_ACCOUNT_NUMBER)
);


drop table loan;


desc LOAN;
select * from LOAN;

LOAD DATA INFILE
 'C:/loans.csv'
INTO TABLE LOAN
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

select*FROM LOAN;

drop table loan;

use online_bank;


-- customers trasaction fixed_deposit loan -----------------online banking--------------------

-- Total customer details in Transaction, Fixed deposit and Loan 

select c.CUSTOMER_ACCOUNT_NUMBER as Account_number,ucase(c.CUSTOMER_NAME) as Name,c.BANK_NAME ,c.CUSTOMER_IFSC_CODE as IFSC_CODE,
c.CUSTOMER_PHONE_NUMBER as PHONE_NUMBER,c.CUSTOMER_ACCOUNT_TYPE as ACCOUNT_TYPE,t.TRANSACTION_TYPE as Credit_Debit,t.TRANSACTION_AMOUNT,t.ACCOUNT_BALANCE,
f.FD_ACCOUNT_NUMBER,f.FD_PERIOD_YEAR,f.FD_INTREST,f.FD_AMOUNT,l.LOAN_ACCOUNT_NUMBER,l.LOAN_TENSURE_YEAR,l.LOAN_INTREST,l.LOAN_AMOUNT
from customers as c 
left join transaction as t 
on c.CUSTOMER_ACCOUNT_NUMBER = t.CUSTOMER_ACCOUNT_NUMBER
left join fixed_deposit as f 
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER
left join loan as l 
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER
order by c.CUSTOMER_ID ;
 
-- Customers Fixed deposit Details

select c.CUSTOMER_NAME as Name,c.CUSTOMER_ACCOUNT_NUMBER as Account_number,c.BANK_NAME ,c.CUSTOMER_IFSC_CODE as IFSC_CODE,
c.CUSTOMER_PHONE_NUMBER as PHONE_NUMBER,c.CUSTOMER_ACCOUNT_TYPE as ACCOUNT_TYPE,f.FD_ACCOUNT_NUMBER,f.FD_PERIOD_YEAR,
f.FD_INTREST,f.FD_AMOUNT
from customers as c left join fixed_deposit as f
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER;

-- Customers Loan Details

select c.CUSTOMER_NAME as Name,c.CUSTOMER_ACCOUNT_NUMBER as Account_number,c.BANK_NAME ,c.CUSTOMER_IFSC_CODE as IFSC_CODE,
c.CUSTOMER_PHONE_NUMBER as PHONE_NUMBER,c.CUSTOMER_ACCOUNT_TYPE as ACCOUNT_TYPE,l.LOAN_TENSURE_YEAR,
l.LOAN_INTREST,l.LOAN_AMOUNT
from customers as c left join loan as l
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER;

-- Customers Transaction Details
select c.CUSTOMER_NAME as Name,c.CUSTOMER_ACCOUNT_NUMBER as Account_number,c.BANK_NAME ,c.CUSTOMER_IFSC_CODE as IFSC_CODE,
c.CUSTOMER_PHONE_NUMBER as PHONE_NUMBER,c.CUSTOMER_ACCOUNT_TYPE as ACCOUNT_TYPE,t.TRANSACTION_TYPE,t.TRANSACTION_AMOUNT,t.ACCOUNT_BALANCE
from customers as c left join transaction as t 
on c.CUSTOMER_ACCOUNT_NUMBER = t.CUSTOMER_ACCOUNT_NUMBER;

-- customers balance details
select c.CUSTOMER_NAME as Name,c.CUSTOMER_ACCOUNT_NUMBER as Account_number,c.BANK_NAME,t.ACCOUNT_BALANCE
from customers as c left join transaction as t 
on c.CUSTOMER_ACCOUNT_NUMBER = t.CUSTOMER_ACCOUNT_NUMBER
order by c.CUSTOMER_ID;

-- tpo 10 customers fixed deposit 
select c.CUSTOMER_ACCOUNT_NUMBER,f.FD_START_DATE,f.FD_END_DATE,f.FD_AMOUNT
from customers as c inner join fixed_deposit as f
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER order by f.FD_AMOUNT desc limit 10;

-- top 10 customers loan amount
select c.CUSTOMER_ACCOUNT_NUMBER,l.LOAN_START_DATE,l.LOAN_END_DATE,l.LOAN_AMOUNT
from customers as c inner join loan as l
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER 
order by l.LOAN_AMOUNT desc limit 10;  

-- top 10 cutomers transaction
select c.CUSTOMER_id,c.CUSTOMER_ACCOUNT_NUMBER,count(c.CUSTOMER_ACCOUNT_NUMBER),t.TRANSACTION_AMOUNT,t.ACCOUNT_BALANCE
from customers as c left join transaction as t
on c.CUSTOMER_ACCOUNT_NUMBER = t.CUSTOMER_ACCOUNT_NUMBER 
group by c.CUSTOMER_id,c.CUSTOMER_ACCOUNT_NUMBER,t.TRANSACTION_AMOUNT,t.ACCOUNT_BALANCE order by t.ACCOUNT_BALANCE desc limit 10 ;

-- all customers transaction  
select CUSTOMER_ACCOUNT_NUMBER,count(TRANSACTION_ID) -- ,t.TRANSACTION_AMOUNT
from  transaction  where TRANSACTION_TYPE="debit"
group by CUSTOMER_ACCOUNT_NUMBER;

select CUSTOMER_ACCOUNT_NUMBER,count(TRANSACTION_ID) -- ,t.TRANSACTION_AMOUNT
from  transaction  where TRANSACTION_TYPE is null
group by CUSTOMER_ACCOUNT_NUMBER;

select CUSTOMER_ACCOUNT_NUMBER,count(CUSTOMER_ACCOUNT_NUMBER) -- ,t.TRANSACTION_AMOUNT
from  transaction  where TRANSACTION_TYPE="credit"
group by CUSTOMER_ACCOUNT_NUMBER;

-- how many credit and debit transactions
select TRANSACTION_TYPE,count(TRANSACTION_ID) as TRANSACTION -- ,t.TRANSACTION_AMOUNT
from  transaction
group by TRANSACTION_TYPE;

-- how many customers used credit type trasactions
select t.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.CUSTOMER_NAME,count(t.CUSTOMER_ACCOUNT_NUMBER) AS TRANSACTION
from customers as c left join transaction as t 
on c. CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
where t.TRANSACTION_TYPE ='credit'
group by c.CUSTOMER_NAME,t.CUSTOMER_ACCOUNT_NUMBER  ;

-- how many customers used debit type trasactions
select c.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.CUSTOMER_NAME,count(t. CUSTOMER_ACCOUNT_NUMBER) AS TRANSACTION
from customers as c left join transaction as t 
on c. CUSTOMER_ACCOUNT_NUMBER=t. CUSTOMER_ACCOUNT_NUMBER
where t.TRANSACTION_TYPE ='debit'
group by c.CUSTOMER_ACCOUNT_NUMBER,c.CUSTOMER_NAME;

-- how many credit type transaction in all bank 
select c.BANK_NAME,count(t.CUSTOMER_ACCOUNT_NUMBER) as TRANSACTION
from customers as c inner join transaction as t 
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER where t.TRANSACTION_TYPE="credit"
group by c.BANK_NAME;

-- how many debit type transaction in all bank 
select c.BANK_NAME,count(t.CUSTOMER_ACCOUNT_NUMBER) as TRANSACTION
from customers as c inner join transaction as t 
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER where t.TRANSACTION_TYPE="debit"
group by c.BANK_NAME ;

-- how many transaction in all bank 
select c.BANK_NAME,count(t.CUSTOMER_ACCOUNT_NUMBER) as TRANSACTION
from customers as c inner join transaction as t 
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
group by c.BANK_NAME ;


-- debit type  transaction
select c.CUSTOMER_id,c.CUSTOMER_ACCOUNT_NUMBER,count(c.CUSTOMER_ACCOUNT_NUMBER) as TRANSACTION,t.TRANSACTION_AMOUNT
from customers as c left join transaction as t
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
group by c.CUSTOMER_ID,c.CUSTOMER_ACCOUNT_NUMBER,t.TRANSACTION_AMOUNT,t.TRANSACTION_TYPE 
having t.TRANSACTION_TYPE ="debit"  order by c.CUSTOMER_id;

-- Bank wise customers
select BANK_NAME,count(CUSTOMER_ID) as Customers
from customers group by BANK_NAME ;

-- Bank wise customers loan
select c.BANK_NAME,count(l.LOAN_ID) as Loan_Customers from Customers as c inner join loan as l 
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER
 group by c.BANK_NAME;
 
 -- Bank wise above 500000 to 3000000 loan amount customers
select c.BANK_NAME,count(l.LOAN_ID)as Customers ,l.LOAN_AMOUNT as LoanAmount  from Customers as c inner join loan as l 
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER
group by c.BANK_NAME,l.LOAN_AMOUNT  having l.LOAN_AMOUNT between 500000 and 3000000 ;

-- Bank wise customers fixed deposit
select c.BANK_NAME,count(f.FD_ID) as Customers from Customers as c inner join fixed_deposit as f 
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER
group by c.BANK_NAME;

-- Bank wise above 1000000 fd amount customers
select c.BANK_NAME,count(f.FD_ID),f.FD_AMOUNT as Customers from Customers as c inner join fixed_deposit as f 
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER
group by c.BANK_NAME,f.FD_AMOUNT having f.FD_AMOUNT > 1000000;

-- no loan balance customers
select c.CUSTOMER_NAME,c.CUSTOMER_ACCOUNT_NUMBER,c.BANK_NAME,l.LOAN_TENSURE_YEAR as YEAR,l.LOAN_END_DATE,l.LOAN_AMOUNT
from customers as c inner join loan as l 
on c.CUSTOMER_ACCOUNT_NUMBER=l.LOAN_ACCOUNT_NUMBER
where l.LOAN_NODUE_AMOUNT = false;

-- current loan due amount customers 
select c.CUSTOMER_NAME,c.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.BANK_NAME,l.LOAN_TENSURE_YEAR as YEAR,l.LOAN_END_DATE,l.LOAN_AMOUNT
from customers as c inner join loan as l 
on c.CUSTOMER_ACCOUNT_NUMBER=l.LOAN_ACCOUNT_NUMBER
where l.LOAN_NODUE_AMOUNT = true;

-- in active customers bank balance
select c.CUSTOMER_NAME,c.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.BANK_NAME,t.ACCOUNT_BALANCE
from customers as c inner join transaction as t
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
where c.CUSTOMER_ACCOUNT_STATUS =false;

-- active customers bank balance
select c.CUSTOMER_NAME,c.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.BANK_NAME,t.ACCOUNT_BALANCE
from customers as c inner join transaction as t
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
where c.CUSTOMER_ACCOUNT_STATUS =true;

-- last 1 year how many customer to take loan from SBI bank 
select distinct  c.BANK_NAME,count(l.LOAN_ACCOUNT_NUMBER) as Customers from Customers as c inner join loan as l 
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER
where l.LOAN_START_DATE between "2023-01-01" and curdate() 
group by  c.BANK_NAME;

-- last 5 month how many customer fixed deposit bank wise
select c.BANK_NAME,COUNT(f.FD_ACCOUNT_NUMBER) AS CUSTOMERS from Customers as c inner join fixed_deposit as f 
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  f.FD_START_DATE >= now() - interval 5 month
group by c.BANK_NAME ;

-- last 5 month how many customer fixed deposit bank SBI
select c.BANK_NAME,COUNT(f.FD_ACCOUNT_NUMBER) from Customers as c inner join fixed_deposit as f 
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  f.FD_START_DATE >= now() - interval 5 month
group by c.BANK_NAME having c.BANK_NAME = "SBI";

-- first quater of the year in sbi fixed deposit customers
select c.BANK_NAME,c.CUSTOMER_ACCOUNT_NUMBER,f.FD_AMOUNT,COUNT(f.FD_ACCOUNT_NUMBER) as COUNT from Customers as c right join fixed_deposit as f 
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  month(f.FD_START_DATE) in (1,2,3) and year(f.FD_START_DATE) in ("2023")
group by c.BANK_NAME,c.CUSTOMER_ACCOUNT_NUMBER,f.FD_AMOUNT having c.BANK_NAME = "SBI";

-- month wise all bank fd amount 
select c.BANK_NAME ,monthname(f.FD_START_DATE) as month,sum(f.FD_AMOUNT) as total
from customers as c inner join fixed_deposit as f 
on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER
group by monthname(f.FD_START_DATE),c.BANK_NAME ;


-- analytic functiond
-- inline lag and over
select month,amount,bank_name ,month_number,lag(amount) over(order by month_number) as previous_year_amount
from(
	select c.BANK_NAME ,monthname(f.FD_START_DATE) as MONTH,sum(f.FD_AMOUNT) as AMOUNT,month(f.FD_START_DATE) as month_number
	from customers as c inner join fixed_deposit as f 
	on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  month(f.FD_START_DATE) in (1,2,3) and year(f.FD_START_DATE) in ("2023")
	group by month(f.FD_START_DATE), monthname(f.FD_START_DATE),c.BANK_NAME having c.BANK_NAME="SBI" 
    ) as result  order by month_number;
    
-- inline lead and over 
select month,amount,bank_name ,month_number,lead(amount) over(order by month_number) as previous_year_amount
from(
	select c.BANK_NAME ,monthname(f.FD_START_DATE) as MONTH,sum(f.FD_AMOUNT) as AMOUNT,month(f.FD_START_DATE) as month_number
	from customers as c inner join fixed_deposit as f 
	on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER -- where  month(f.FD_START_DATE) in (1,2,3) and year(f.FD_START_DATE) in ("2023")
	group by month(f.FD_START_DATE), monthname(f.FD_START_DATE),c.BANK_NAME having c.BANK_NAME="SBI" 
    ) as result  ;

select max("2023-12-17");

-- first quater of the year in sbi fixed deposit customers amounts
select c.BANK_NAME ,monthname(f.FD_START_DATE) as MONTH,sum(f.FD_AMOUNT) as AMOUNT
from customers as c inner join fixed_deposit as f 
on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  month(f.FD_START_DATE) in (1,2,3) and year(f.FD_START_DATE) in ("2023")
group by monthname(f.FD_START_DATE),c.BANK_NAME having c.BANK_NAME="SBI" order by max(f.FD_START_DATE) ;

-- second quater of the year in sbi fixed deposit customers amounts
select c.BANK_NAME ,monthname(f.FD_START_DATE) as MONTH,sum(f.FD_AMOUNT) as TOTAL 
from customers as c inner join fixed_deposit as f 
on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  month(f.FD_START_DATE) in (4,5,6) and year(f.FD_START_DATE) in ("2023")
group by monthname(f.FD_START_DATE),c.BANK_NAME having c.BANK_NAME="SBI" order by max(f.FD_START_DATE) ;


-- third quater of the year in sbi fixed deposit customers
select c.BANK_NAME ,monthname(f.FD_START_DATE) as MONTH,sum(f.FD_AMOUNT) as TOTAL 
from customers as c inner join fixed_deposit as f 
on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  month(f.FD_START_DATE) in (7,8,9) and year(f.FD_START_DATE) in ("2023")
group by monthname(f.FD_START_DATE),c.BANK_NAME having c.BANK_NAME="SBI" order by max(f.FD_START_DATE) ;


-- fourth quater of the year in sbi fixed deposit customers
select c.BANK_NAME ,monthname(f.FD_START_DATE) as MONTH,sum(f.FD_AMOUNT) as TOTAL 
from customers as c inner join fixed_deposit as f 
on  c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER where  month(f.FD_START_DATE) in (10,11,12) and year(f.FD_START_DATE) in ("2023")
group by monthname(f.FD_START_DATE),c.BANK_NAME having c.BANK_NAME="SBI" order by max(f.FD_START_DATE) ;


-- lowest bank balance customer 
select c.CUSTOMER_NAME,c.BANK_NAME,t.ACCOUNT_BALANCE
from customers as c inner join transaction as t
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
order by t.ACCOUNT_BALANCE  limit 1;

-- highest bank balance
select c.CUSTOMER_NAME,c.BANK_NAME,t.ACCOUNT_BALANCE
from customers as c inner join transaction as t
on c.CUSTOMER_ACCOUNT_NUMBER=t.CUSTOMER_ACCOUNT_NUMBER
order by t.ACCOUNT_BALANCE desc  limit 1;

-- top 5 highest loan intrest amount customer 
select c.CUSTOMER_NAME,c.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.BANK_NAME,l.LOAN_INTREST,l.LOAN_AMOUNT
from customers as c inner join loan as l
on c.CUSTOMER_ACCOUNT_NUMBER=l.LOAN_ACCOUNT_NUMBER
order by l.LOAN_INTREST desc limit 5;

-- top 5 lowest fixed deposit intrest amount customers
select c.CUSTOMER_NAME,c.CUSTOMER_ACCOUNT_NUMBER as ACCOUNT_NUMBER,c.BANK_NAME,f.FD_INTREST,f.FD_AMOUNT
from customers as c inner join fixed_deposit as f
on c.CUSTOMER_ACCOUNT_NUMBER = f.FD_ACCOUNT_NUMBER
order by f.FD_INTREST  limit 5;

-- group the loan type bank wise how many customers
select c.BANK_NAME,l.LOAN_TYPE,count(c.CUSTOMER_ACCOUNT_NUMBER) as CUSTOMERS
from customers as c right join loan as l
on c.CUSTOMER_ACCOUNT_NUMBER = l.LOAN_ACCOUNT_NUMBER
group by c.BANK_NAME,l.LOAN_TYPE;












