select * from esign.tb_user;

select * from esign.tb_user where user_id = '90000003';

use storedb;


CREATE TABLE sales.codes (
	code varchar(25) NOT NULL,
	code_nm varchar(25) NOT NULL,
	code_desc varchar(25) NOT NULL,
	code_group varchar(25),
	CONSTRAINT codes_code_pk PRIMARY KEY (code),
	CONSTRAINT codes_code_group_fk FOREIGN KEY (code_group)   REFERENCES sales.codes (code)
);




INSERT INTO storedb.sales.codes
	(code, code_nm, code_desc)
VALUES 
	('VC', 'VIRTUAL_COIN', '가상화폐');

INSERT INTO storedb.sales.codes
	(code, code_nm, code_desc, code_group)
VALUES 
	('BTC', 'BIT_COIN', '비트코인', 'VC');
	
INSERT INTO storedb.sales.codes
	(code, code_nm, code_desc, code_group)
VALUES 
	('ETH', 'ETHEREUM', '이더리움', 'VC');

INSERT INTO storedb.sales.codes
	(code, code_nm, code_desc, code_group)
VALUES 
	('LTC', 'LITE_COIN', '라이트코인', 'VC');

INSERT INTO storedb.sales.codes
	(code, code_nm, code_desc, code_group)
VALUES 
	('XRP', 'RIPPLE', '리플', 'VC');

	
select * from sales.codes;
	
select 
c.code,
c.code_nm,
c.code_desc,
cp.code as code_group,
cp.code_nm as code_group_nm
from sales.codes c left join sales.codes cp
on c.code_group = cp.code;

 
create view sales.codes_view as
	select 
	c.code,
	c.code_nm,
	c.code_desc,
	cp.code as code_group,
	cp.code_nm as code_group_nm
	from sales.codes c left join sales.codes cp
	on c.code_group = cp.code;

select * from sales.codes_view;

	
CREATE TABLE sales.user_virtual_coins
(
	id int IDENTITY (1,1) NOT NULL,
	username varchar(50) NOT NULL,
	virtual_coin varchar(25) NOT NULL,
	amount int DEFAULT 0 NOT NULL,
	CONSTRAINT user_virtual_coins_id_pk PRIMARY KEY (id),
	CONSTRAINT user_virtual_coins_virtual_coin_fk FOREIGN KEY (virtual_coin)   REFERENCES sales.codes (code)
);



INSERT INTO storedb.sales.user_virtual_coins
	(username, virtual_coin, amount)
VALUES 
	('stoneberg', 'BTC', 100);

select * from sales.codes_view;
select * from sales.user_virtual_coins;


CREATE TABLE sales.investors
(
	username varchar(50) NOT NULL,
	firstname varchar(25) NOT NULL,
	lastname varchar(25) NOT NULL,
	email varchar(50),
	use_yn varchar(1) NOT NULL DEFAULT 'Y',
	CONSTRAINT investors_username_pk PRIMARY KEY (username)
);


INSERT INTO sales.investors
	(username, firstname, lastname, email, use_yn)
VALUES 
	('stoneberg', 'lee', 'yu pyeong', 'stoneberg@gmail.net', 'Y');

INSERT INTO sales.investors
	(username, firstname, lastname, email, use_yn)
VALUES 
	('zetlee', 'lee', 'ho jae', 'zetlee@gmail.net', 'Y');
	
INSERT INTO sales.investors
	(username, firstname, lastname, email, use_yn)
VALUES 
	('redfoxer', 'lee', 'sang', 'redfoxer@gmail.net', 'N');
	

ALTER TABLE sales.investors ADD use_yn varchar(1) NOT NULL DEFAULT 'Y';


select * from sales.investors;

select
i.username,
i.firstname,
i.lastname,
i.email,
i.use_yn,
c.virtual_coin,
c.amount
from sales.investors i inner join sales.user_virtual_coins c
on i.username = c.username;


select * from sales.user_virtual_coins;


use storedb;

CREATE TABLE sales.app_users
(
	id int IDENTITY (1,1) NOT NULL,
	username varchar(50) NOT NULL,
	fullname varchar(50) NOT NULL,
	password varchar(255) NOT NULL,
	deptname varchar(25) NOT NULL,
	position varchar(25) NOT NULL,
	email varchar(50) NOT NULL,
	user_type varchar(25),
	CONSTRAINT app_users_id_pk PRIMARY KEY (id),
	CONSTRAINT app_users_email_uc UNIQUE(email)  
);




INSERT INTO sales.app_users
	(username, fullname, password, deptname, position, email, user_type)
VALUES 
	('stoneberg', 'lee yupyeong', '$2a$10$oV1xXItlbl80Luh9Ujm67e9b1Oyc7Hj.79tp/OG3BZyERzVqW63lm', '개발부', '차장', 'stoneberg@gmail.net', 'SA'),
	('zetlee', 'lee hojae', '$2a$10$1aXri0rCydsZt6y1u0PM/eHysVJorggeN0Zd6UxhNslmA80QDzcMq', '영업무', '과장', 'zetlee@gmail.net', 'SD'),
	('redfoxer', 'lee sang', '$2a$10$rt/OZ9Wg6Rqz831GJ/PLm.FCyAN0.BftCzLY7glmN5llqViuBzN0G', '관리부', '차장', 'redfoxer@gmail.net', 'SC');


select * from sales.app_users;

select * from tb_roles;

use devops;


select * from tb_user_roles;

select * from tb_deployment;

-- LIMIT offset, limit (careful comma!)
select * from tb_deployment
limit 0, 10;

select * from tb_deployment
limit 10, 10;

-- LIMIT, OFFSET
select * from tb_deployment
limit 10 offset 0;

select * from tb_deployment
limit 10 offset 10;
















































































































































































































































