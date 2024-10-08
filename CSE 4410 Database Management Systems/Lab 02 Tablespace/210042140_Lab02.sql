--1
CREATE TABLESPACE TBS1
DATAFILE 'C:\Users\mahmu\MySql\2nd Semester\Lab 02\tbs1_data.dbf' SIZE 1M
AUTOEXTEND ON NEXT 1M;
CREATE TABLESPACE TBS2
DATAFILE 'C:\Users\mahmu\MySql\2nd Semester\Lab 02\tbs2_data.dbf' SIZE 1M
AUTOEXTEND ON NEXT 1M


--2
DROP USER iutlearner;

CREATE USER iutlearner
IDENTIFIED BY test123
DEFAULT TABLESPACE TBS1
QUOTA UNLIMITED ON tbs1
QUOTA 500K ON tbs2;


--3
CREATE TABLE Department (
  ID INT,
  Name VARCHAR2(32),
  CONSTRAINT PK_Department PRIMARY KEY (ID)
) TABLESPACE TBS1;


CREATE TABLE Student (
  ID INT,
  Name VARCHAR(50),
  dept_ID INT,
  CONSTRAINT PK_Student PRIMARY KEY (ID),
  CONSTRAINT FK_dept FOREIGN KEY (dept_ID) REFERENCES Department(ID)
) TABLESPACE TBS1;


--4
CREATE TABLE Course (
  Course_code VARCHAR2(10),
  Name VARCHAR2(255),
  Credit INT,
  Offered_by_dept_ID INT,
  CONSTRAINT PK_Course PRIMARY KEY (Course_code),
  CONSTRAINT FK_Offered_by_dept FOREIGN KEY (offered_by_dept_ID) REFERENCES Department(ID)
) TABLESPACE tbs2;



--5
@"C:\Users\mahmu\MySql\2nd Semester\Lab 02\data.sql";


--6
SELECT C.name AS course_title,D.name AS department_name
FROM Course C LEFT JOIN Department D 
ON C.offered_by_dept_ID = D.ID;


--7
SELECT TABLESPACE_NAME, BYTES/1024/1024 MB
FROM DBA_FREE_SPACE
WHERE TABLESPACE_NAME='TBS1'


--8
ALTER TABLESPACE TBS1
ADD DATAFILE 'C:\Users\mahmu\MySql\2nd Semester\Lab 02\tbs1_data_extend.dbf' SIZE 10M;


--9
ALTER DATABASE
DATAFILE 'C:\Users\mahmu\MySql\2nd Semester\Lab 02\tbs2_data.dbf' RESIZE 15M;


--10
SELECT tablespace_name, round(sum(bytes) / (1024 * 1024), 2) as tablespace_size_mb
FROM dba_data_files
GROUP BY tablespace_name;


--11
ALTER TABLESPACE TBS1 OFFLINE;
SELECT * FROM Department;



--12
DROP TABLESPACE tbs1
INCLUDING CONTENTS AND DATAFILES
CASCADE CONSTRAINTS;


--13
DROP TABLESPACE tbs2
INCLUDING CONTENTS KEEP DATAFILES
CASCADE CONSTRAINTS;