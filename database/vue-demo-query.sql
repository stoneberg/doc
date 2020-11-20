
CREATE TABLE vuedemo.play.boards (
	board_id serial NOT NULL,
	board_type varchar(255) NOT NULL,
	"content" text NOT NULL,
	created_at timestamp,
	subject varchar(50) NOT NULL,
	updated_at timestamp,
	user_id int8,
	PRIMARY KEY (board_id)
);

ALTER TABLE vuedemo.play.boards
	ADD FOREIGN KEY (user_id) 
	REFERENCES users (user_id);
	
select * from users;
	
select * from boards;
	
	
	
select * from posts;
	
select * from stone.et_admins;

INSERT INTO demo.stone.et_clients
	("name")
VALUES 
	('haha');
	
INSERT INTO demo.stone.et_clients
	("name")
VALUES 
	('jaesuk');
	
INSERT INTO demo.stone.et_clients
	("name")
VALUES 
	('deadu');



select * from stone.et_clients;
	
	
select * from et_roles;
DELETE FROM et_roles WHERE "id" = 5;	
	
INSERT INTO rt_roles (name) VALUES ('ROLE_USER');
INSERT INTO rt_roles (name) VALUES ('ROLE_ADMIN');	
select * from rt_roles;

select * from rt_users;
select * from rt_user_roles;
	
	
select * from jojo_academy;
delete from jojo_academy;
	
select * from jojo_teacher;	
delete from jojo_teacher;
	
select * from jojo_subject;	
delete from jojo_subject;	
	
	
select * from demo_board;
	
select * from demo_images;	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	



