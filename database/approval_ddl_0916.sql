
CREATE TABLE tb_link_system (
	link_system_id bigserial NOT NULL,
	system_id varchar(30) NOT NULL,
	system_key TEXT NOT NULL,
	system_name varchar(100) NOT NULL,
	use_yn char(1) DEFAULT 'Y' NOT NULL,
	link_created_dt timestamp NOT NULL,
	link_removed_dt timestamp,
	created_by varchar(70),
	created_dt timestamp,
	updated_by varchar(70),
	updated_dt timestamp,
	PRIMARY KEY (link_system_id)
);

CREATE TABLE tb_approval (
	approval_id bigserial NOT NULL, 
	src_appr_work_id varchar(40), 
	link_system_id int8, 
	approval_name varchar(60) NOT NULL, 
	approval_contents TEXT NOT NULL, 
	callback_url varchar(300), 
	approval_type varchar(20) DEFAULT 'SERIES' NOT NULL, 
	approval_sttus varchar(20), 
	requested_dt timestamp NOT NULL, 
	approved_dt timestamp NOT NULL, 
	progs_sttus varchar(20) DEFAULT 'ONGOING' NOT NULL, 
	delete_yn char(1) DEFAULT 'N' NOT NULL, 
	company_id varchar(75), 
	dept_id varchar(75), 
	user_id varchar(75), 
	created_by varchar(70), 
	created_dt timestamp, 
	updated_by varchar(70), 
	updated_dt timestamp, 
	PRIMARY KEY (approval_id)
);

CREATE TABLE tb_approval_file (
	file_id bigserial NOT NULL, 
	file_name varchar(255) NOT NULL, 
	file_no varchar(10) NOT NULL, 
	file_path varchar(255) NOT NULL, 
	file_url varchar(255) NOT NULL, 
	file_size bigint NOT NULL, 
	approval_id int8, 
	created_by varchar(70), 
	created_dt timestamp, 
	updated_by varchar(70), 
	updated_dt timestamp, 
	PRIMARY KEY (file_id)
);

CREATE TABLE tb_approver (
	approver_id bigserial NOT NULL, 
	approval_order varchar(10) NOT NULL, 
	approval_sttus varchar(20), 
	approved_dt timestamp NOT NULL, 
	progs_sttus varchar(20) DEFAULT 'ONGOING' NOT NULL, 
	COMMENT varchar(300) NOT NULL, 
	approval_id int8, 
	company_id varchar(75), 
	user_id varchar(75), 
	created_by varchar(70), 
	created_dt timestamp, 
	updated_by varchar(70), 
	updated_dt timestamp, 
	PRIMARY KEY (approver_id)
);

CREATE TABLE tb_code (
	code_id varchar(20) NOT NULL, 
	group_code_id varchar(20), 
	code_desc varchar(50) NOT NULL, 
	code_val varchar(20), 
	display_order varchar(10), 
	created_dt timestamp, 
	updated_dt timestamp, 
	PRIMARY KEY (code_id)
);

CREATE TABLE tb_group_code (
	group_code_id varchar(20) NOT NULL,
	group_desc varchar(50) NOT NULL,
	created_dt timestamp,
	updated_dt timestamp,
	PRIMARY KEY (group_code_id)
);

CREATE TABLE tb_role (
	role_id bigserial NOT NULL,
	role_type varchar(20),
	created_by varchar(70),
	created_dt timestamp,
	updated_by varchar(70),
	updated_dt timestamp,
	PRIMARY KEY (role_id)
);

create table tb_system_link_hist (
  system_link_hist_id  bigserial not null, 
  callback_url varchar(300), 
  error_yn char(1) default 'N' not null, 
  link_dt timestamp not null, 
  link_end_point varchar(255) not null, 
  link_log text not null, 
  trans_type varchar(20) not null, 
  source_system_id varchar(30) not null, 
  target_system_id varchar(30) not null, 
  created_by varchar(70), 
  created_dt timestamp, 
  updated_by varchar(70), 
  updated_dt timestamp, 
  primary key (system_link_hist_id)
);

CREATE TABLE tb_company (
	company_id varchar(75) NOT NULL,
	created_by varchar(70),
	created_dt timestamp,
	updated_by varchar(70),
	updated_dt timestamp,
	company_name varchar(75) NOT NULL,
	display_order varchar(10),
	PRIMARY KEY (company_id)
);

CREATE TABLE tb_user (
	company_id varchar(75) NOT NULL,
	user_id varchar(75) NOT NULL,
	created_by varchar(70),
	created_dt timestamp,
	updated_by varchar(70),
	updated_dt timestamp,
	delegate_end_dt timestamp,
	delegate_start_dt timestamp,
	delegate_sttus varchar(20) DEFAULT 'DISMISS',
	delete_yn char(1) DEFAULT 'N' NOT NULL,
	dept_id varchar(75),
	dept_name varchar(75),
	email varchar(75) NOT NULL,
	emp_no varchar(75),
	phone varchar(75),
	user_type varchar(20) DEFAULT 'STAFF' NOT NULL,
	username varchar(75) NOT NULL,
	delegator_company_id varchar(75),
	delegator_user_id varchar(75),
	PRIMARY KEY (company_id, user_id)
);

CREATE TABLE tb_user_access_hist (
	access_hist_id bigserial NOT NULL, 
	access_end_point varchar(255), 
	company_id varchar(75), 
	company_name varchar(75), 
	dept_id varchar(75), 
	dept_name varchar(75), 
	email varchar(75) NOT NULL, 
	last_access_dt timestamp, 
	phone varchar(75), 
	user_id varchar(75) NOT NULL, 
	username varchar(75) NOT NULL, 
	PRIMARY KEY (access_hist_id)
);

CREATE TABLE tb_user_noti (
	user_noti_id bigserial NOT NULL, 
	created_by varchar(70), 
	created_dt timestamp, 
	updated_by varchar(70), 
	updated_dt timestamp, 
	noti_direction varchar(20) NOT NULL, 
	noti_type varchar(20) NOT NULL, 
	company_id varchar(75), 
	user_id varchar(75), 
	PRIMARY KEY (user_noti_id)
);

CREATE TABLE tb_user_role (
	use_role_id bigserial NOT NULL, 
	created_by varchar(70), 
	created_dt timestamp, 
	updated_by varchar(70), 
	updated_dt timestamp, 
	use_yn char(1) DEFAULT 'Y' NOT NULL, 
	role_id int8, 
	company_id varchar(75), 
	user_id varchar(75), 
	PRIMARY KEY (use_role_id)
);

ALTER TABLE tb_user ADD CONSTRAINT uk_tb_user_unique UNIQUE (emp_no, email);

ALTER TABLE tb_approval ADD CONSTRAINT fk_tb_approval_link_system_id FOREIGN KEY (link_system_id) REFERENCES tb_link_system;

ALTER TABLE tb_approval ADD CONSTRAINT fk_tb_approval_user_pk FOREIGN KEY (company_id, user_id) REFERENCES tb_user;

ALTER TABLE tb_approval_file ADD CONSTRAINT fk_tb_approval_file_approval_id FOREIGN KEY (approval_id) REFERENCES tb_approval;

ALTER TABLE tb_approver ADD CONSTRAINT fk_tb_approver_approval_id FOREIGN KEY (approval_id) REFERENCES tb_approval;

ALTER TABLE tb_approver ADD CONSTRAINT fk_tb_approver_user_pk FOREIGN KEY (company_id, user_id) REFERENCES tb_user;

ALTER TABLE tb_code ADD CONSTRAINT fk_tb_code_group_code_id FOREIGN KEY (group_code_id) REFERENCES tb_group_code;

ALTER TABLE tb_user ADD CONSTRAINT fk_tb_user_company_id FOREIGN KEY (company_id) REFERENCES tb_company;

ALTER TABLE tb_user ADD CONSTRAINT fk_tb_user_delegator_pk FOREIGN KEY (delegator_company_id, delegator_user_id) REFERENCES tb_user;

ALTER TABLE tb_user ADD CONSTRAINT fk_tb_user_delegator_company_id FOREIGN KEY (delegator_company_id) REFERENCES tb_company;

ALTER TABLE tb_user_noti ADD CONSTRAINT fk_tb_user_noti_user_pk FOREIGN KEY (company_id, user_id) REFERENCES tb_user;

ALTER TABLE tb_user_role ADD CONSTRAINT fk_tb_user_role_role_id FOREIGN KEY (role_id) REFERENCES tb_role;

ALTER TABLE tb_user_role ADD CONSTRAINT fk_tb_user_role_user_pk FOREIGN KEY (company_id, user_id) REFERENCES tb_user;

