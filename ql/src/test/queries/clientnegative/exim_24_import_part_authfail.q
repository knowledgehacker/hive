set hive.test.mode=true;
set hive.test.mode.prefix=;
set hive.test.mode.nosamplelist=exim_department,exim_employee;

create table exim_employee ( emp_id int comment "employee id") 	
	comment "employee table"
	partitioned by (emp_country string comment "two char iso code", emp_state string comment "free text")
	stored as textfile	
	tblproperties("creator"="krishna");
load data local inpath "../data/files/test.dat" 
	into table exim_employee partition (emp_country="in", emp_state="tn");		
dfs -mkdir ../build/ql/test/data/exports/exim_employee/temp;
dfs -rmr ../build/ql/test/data/exports/exim_employee;
export table exim_employee to 'ql/test/data/exports/exim_employee';
drop table exim_employee;

create database importer;
use importer;
create table exim_employee ( emp_id int comment "employee id") 	
	comment "employee table"
	partitioned by (emp_country string comment "two char iso code", emp_state string comment "free text")
	stored as textfile	
	tblproperties("creator"="krishna");

set hive.security.authorization.enabled=true;
import from 'ql/test/data/exports/exim_employee';
set hive.security.authorization.enabled=false;

dfs -rmr ../build/ql/test/data/exports/exim_employee;
drop table exim_employee;
drop database importer;
