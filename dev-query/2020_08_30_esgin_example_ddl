CREATE TABLE example_board
  (
     id         BIGSERIAL NOT NULL,
     content    TEXT,
     title      VARCHAR(100) NOT NULL,
     created_dt TIMESTAMP,
     updated_dt TIMESTAMP,
     PRIMARY KEY (id)
  );

CREATE TABLE example_company
  (
     cmpn_id      VARCHAR(75) NOT NULL,
     cmpn_name    VARCHAR(75) NOT NULL,
     diplay_order VARCHAR(75) NOT NULL,
     created_dt   TIMESTAMP,
     updated_dt   TIMESTAMP,
     PRIMARY KEY (cmpn_id)
  );

CREATE TABLE example_images
  (
     id         BIGSERIAL NOT NULL,
     name       VARCHAR(100) NOT NULL,
     path       VARCHAR(100) NOT NULL,
     board_id   INT8,
     created_dt TIMESTAMP,
     updated_dt TIMESTAMP,
     PRIMARY KEY (id)
  );

CREATE TABLE example_noti
  (
     id        BIGSERIAL NOT NULL,
     noti_type VARCHAR(255),
     PRIMARY KEY (id)
  );

CREATE TABLE example_user
  (
     user_id        VARCHAR(75) NOT NULL,
     dept_id        VARCHAR(75) NOT NULL,
     email          VARCHAR(75) NOT NULL,
     emp_name       VARCHAR(75) NOT NULL,
     emp_no         VARCHAR(75) NOT NULL,
     phone          VARCHAR(75) NOT NULL,
     sign_file_name VARCHAR(255),
     sign_file_path VARCHAR(255),
     cmpn_id        VARCHAR(75),
     created_dt     TIMESTAMP,
     updated_dt     TIMESTAMP,
     PRIMARY KEY (user_id)
  );

CREATE TABLE example_user_noti
  (
     id               BIGSERIAL NOT NULL,
     noti_direct_type VARCHAR(255),
     noti_type        VARCHAR(255),
     user_id          VARCHAR(75),
     created_dt       TIMESTAMP,
     updated_dt       TIMESTAMP,
     PRIMARY KEY (id)
  );

CREATE TABLE example_user_pledge
  (
     id               BIGSERIAL NOT NULL,
     contents_type    VARCHAR(20),
     end_dt           TIMESTAMP,
     pledge_name      VARCHAR(60) NOT NULL,
     progs_sttus_type VARCHAR(20),
     req_dept         VARCHAR(20) NOT NULL,
     req_user         VARCHAR(30) NOT NULL,
     start_dt         TIMESTAMP,
     created_dt       TIMESTAMP,
     updated_dt       TIMESTAMP,
     PRIMARY KEY (id)
  );

ALTER TABLE example_user
  ADD CONSTRAINT uk_ex_user_email UNIQUE (email);

ALTER TABLE example_user
  ADD CONSTRAINT uk_ex_user_emp_no UNIQUE (emp_no);

ALTER TABLE example_images
  ADD CONSTRAINT fk_ex_images_ex_board FOREIGN KEY (board_id) REFERENCES
  example_board;

ALTER TABLE example_user
  ADD CONSTRAINT fk_ex_user_cmpn_id FOREIGN KEY (cmpn_id) REFERENCES
  example_company;

ALTER TABLE example_user_noti
  ADD CONSTRAINT fk_ex_user_noti_user_id FOREIGN KEY (user_id) REFERENCES
  example_user; 