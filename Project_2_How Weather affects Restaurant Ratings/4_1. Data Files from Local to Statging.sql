--Database: UD_DW---
--Schema: Staging---
--Worksheet : UD_DW.Staging--

CREATE SCHEMA "UD_DW"."STAGING";
USE SCHEMA STAGING;
-----YELP DATA------

/* Create a simple JSON file format*/
create or replace file format myjsonformat type='JSON' strip_outer_array=true;

/* Create a staging area */
create or replace stage my_json_stage file_format = myjsonformat;

/* Create table and copy data to yelp_business */
create table yelp_business(userjson variant);

put 'file://C:\\Users\\abhiskum\\Desktop\\Data Architect\\2. Designing a DW for Reporting and OLAP\\How Weather affects Restaurant Ratings\\yelp_academic_dataset_business.json' @my_json_stage auto_compress=true;

copy into yelp_business from @my_json_stage /yelp_academic_dataset_business.json.gz file_format=myjsonformat on_error='skip_file';

/* Create table and copy data to yelp_checkin */
create table yelp_checkin(userjson variant);

put 'file://C:\\Users\\abhiskum\\Desktop\\Data Architect\\2. Designing a DW for Reporting and OLAP\\How Weather affects Restaurant Ratings\\yelp_academic_dataset_checkin.json' @my_json_stage auto_compress=true;

copy into yelp_checkin from @my_json_stage/yelp_academic_dataset_checkin.json.gz file_format=myjsonformat on_error='skip_file';

/* Create table and copy data to yelp_review */
create table yelp_review(userjson variant);

put 'file://C:\\Users\\abhiskum\\Desktop\\Data Architect\\2. Designing a DW for Reporting and OLAP\\How Weather affects Restaurant Ratings\\yelp_academic_dataset_review.json' @my_json_stage auto_compress=true;

copy into yelp_review from @my_json_stage/yelp_academic_dataset_review.json.gz file_format=myjsonformat on_error='skip_file';

/* Create table and copy data to yelp_tip */
create table yelp_tip(userjson variant);

put 'file://C:\\Users\\abhiskum\\Desktop\\Data Architect\\2. Designing a DW for Reporting and OLAP\\How Weather affects Restaurant Ratings\\yelp_academic_dataset_tip.json' @my_json_stage auto_compress=true;

copy into yelp_tip from @my_json_stage/yelp_academic_dataset_tip.json.gz file_format=myjsonformat on_error='skip_file';

/* Create table and copy data to yelp_user */
create table yelp_user(userjson variant);

put 'file://C:\\Users\\abhiskum\\Desktop\\Data Architect\\2. Designing a DW for Reporting and OLAP\\How Weather affects Restaurant Ratings\\yelp_academic_dataset_user.json' @my_json_stage auto_compress=true;

copy into yelp_user from @my_json_stage/yelp_academic_dataset_user.json.gz file_format=myjsonformat on_error='skip_file';

/* Create table and copy data to yelp_covid_features */
create table yelp_covid_features(userjson variant);

put 'file://C:\\Users\\abhiskum\\Desktop\\Data Architect\\2. Designing a DW for Reporting and OLAP\\How Weather affects Restaurant Ratings\\\covid_19_dataset_2020_06_10\\yelp_academic_dataset_covid_features.json' @my_json_stage auto_compress=true;

copy into yelp_covid_features from @my_json_stage/yelp_academic_dataset_covid_features.json.gz file_format=myjsonformat on_error='skip_file';

-----CLIMATE DATA------

/* Create table and copy data to climate_temperature to Staging Schema */
DROP TABLE IF EXISTS climate_temperature; 

CREATE TABLE "UD_DW"."STAGING".climate_temperature ("temp_date" STRING, "min" int, "max" int, "normal_min" FLOAT, "normal_max" FLOAT);

create or replace file format mycsvformat  type='CSV' compression='auto' field_delimiter=',' record_delimiter = '\n' skip_header=1 error_on_column_count_mismatch=true null_if = ('NULL', 'null') empty_field_as_null = true;

create or replace stage my_csv_stage file_format = mycsvformat;

PUT 'file://C:\\Users\\abhiskum\\Downloads\\climate_temperature.csv' @MY_CSV_STAGE AUTO_COMPRESS=TRUE;

copy into climate_temperature from @my_csv_stage/climate_temperature.csv.gz file_format=mycsvformat ON_ERROR = 'CONTINUE' PURGE = TRUE;

/* Create table and copy data to climate_precipitation to Staging Schema */
DROP TABLE IF EXISTS climate_precipitation; 

CREATE TABLE "UD_DW"."STAGING".climate_precipitation ("precipitation_date" STRING, "precipitation" FLOAT, "precipitation_normal" FLOAT);

PUT 'file://C:\\Users\\abhiskum\\Downloads\\climate_precipitation.csv' @MY_CSV_STAGE AUTO_COMPRESS=TRUE;

copy into climate_precipitation from @my_csv_stage/climate_precipitation.csv.gz file_format=mycsvformat ON_ERROR = 'CONTINUE' PURGE = TRUE;

