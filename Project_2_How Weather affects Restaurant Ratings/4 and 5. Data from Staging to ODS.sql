--Database: UD_DW---
--Schema: Staging---
--Worksheet : UD_DW.ODS--

---YELP DATA---
CREATE TABLE business (
    business_id varchar(255) PRIMARY KEY, 
    name varchar(255),
    address varchar(255), 
    city varchar(50),
    state varchar(50),
    postal_code varchar(25), 
    latitude float,
    longitude float,
    stars float, 
    review_count int,
    is_open int
);

/*Transforming data from a single JSON structure of staging to multiple columns of ODS*/
INSERT into business
SELECT   
    parse_json($1):business_id, 
    parse_json($1):name,
    parse_json($1):address, 
    parse_json($1):city,
    parse_json($1):state,
    parse_json($1):postal_code, 
    parse_json($1):latitude,
    parse_json($1):longitude,
    parse_json($1):stars, 
    parse_json($1):review_count,
    parse_json($1):is_open
FROM UD_DW.STAGING.yelp_business;



CREATE OR REPLACE TABLE checkin (
    checkin_id int PRIMARY KEY IDENTITY,
    business_id varchar(255),
    checkin_dates TEXT,
    CONSTRAINT FK_business_id_checkin FOREIGN KEY(business_id) REFERENCES business(business_id)
)

/*Transforming data from a single JSON structure of staging to multiple columns of ODS*/
INSERT into checkin(business_id, checkin_dates)
SELECT
    parse_json($1):business_id, 
    parse_json($1):date
FROM UD_DW.STAGING.yelp_checkin;


CREATE OR REPLACE TABLE user (
    user_id varchar(255) PRIMARY KEY,
    compliment_cool int,
    compliment_cute int,
    compliment_funny int,
    compliment_hot int,
    compliment_list int,
    compliment_more int,
    compliment_note int,
    compliment_photos int,
    compliment_plain int,
    compliment_profile int,
    compliment_writer int,
    cool int,
    elite TEXT,
    fans int,
    funny int,
    name varchar(255),
    review_count int,
    useful int,
    yelping_since datetime
)

/*Transforming data from a single JSON structure of staging to multiple columns of ODS*/
INSERT into user
SELECT 
    parse_json($1):user_id,
    parse_json($1):compliment_cool,
    parse_json($1):compliment_cute,
    parse_json($1):compliment_funny,
    parse_json($1):compliment_hot,
    parse_json($1):compliment_list,
    parse_json($1):compliment_more,
    parse_json($1):compliment_note,
    parse_json($1):compliment_photos,
    parse_json($1):compliment_plain,
    parse_json($1):compliment_profile,
    parse_json($1):compliment_writer,
    parse_json($1):cool,
    parse_json($1):elite,
    parse_json($1):fans,
    parse_json($1):funny,
    parse_json($1):name,
    parse_json($1):review_count,
    parse_json($1):useful,
    parse_json($1):yelping_since
FROM UD_DW.STAGING.yelp_user;


CREATE OR REPLACE TABLE tip (
    tip_id int PRIMARY KEY IDENTITY,
    business_id varchar(255),
    user_id varchar(255), 
    compliment_count int,
    tip_date DATETIME,
    tip_text text,
    CONSTRAINT FK_business_id_tip FOREIGN KEY(business_id) REFERENCES business(business_id),
	CONSTRAINT FK_user_id_user FOREIGN KEY(user_id) REFERENCES user(user_id)
)

/*Transforming data from a single JSON structure of staging to multiple columns of ODS*/
INSERT INTO tip (business_id, user_id, compliment_count, tip_date, tip_text)
SELECT
    parse_json($1):business_id, 
    parse_json($1):user_id,
    parse_json($1):compliment_count, 
    parse_json($1):date,
    parse_json($1):text
FROM UD_DW.STAGING.yelp_tip;


CREATE OR REPLACE TABLE covid (
    covid_id int PRIMARY KEY IDENTITY,
    business_id varchar(255),
    "Call To Action enabled" text, 
    "Covid Banner" text,
    "Grubhub enabled" boolean,
    "Request a Quote Enabled" boolean,
    "Temporary Closed Until" text,
    "Virtual Services Offered" text,
    "delivery or takeout" boolean,
    "highlights" text,
    CONSTRAINT FK_business_id_covid FOREIGN KEY(business_id) REFERENCES business(business_id)
)

/*Transforming data from a single JSON structure of staging to multiple columns of ODS*/
INSERT into covid (business_id, "Call To Action enabled", "Covid Banner", "Grubhub enabled", "Request a Quote Enabled",
                  "Temporary Closed Until", "Virtual Services Offered", "delivery or takeout", "highlights")
SELECT 
    parse_json($1):"business_id",
    parse_json($1):"Call To Action enabled",
    parse_json($1):"Covid Banner",
    parse_json($1):"Grubhub enabled",
    parse_json($1):"Request a Quote Enabled",
    parse_json($1):"Temporary Closed Until",
    parse_json($1):"Virtual Services Offered",
    parse_json($1):"delivery or takeout",
    parse_json($1):"highlights"
FROM UD_DW.STAGING.yelp_covid_features;


CREATE OR REPLACE TABLE review (
    review_id Varchar(255) PRIMARY KEY,
    business_id varchar(255),
    user_id varchar(255),
    cool int, 
    review_date DATE,
    funny int,
    stars int, 
    review_text text,
    useful int,
    CONSTRAINT FK_business_id_review FOREIGN KEY(business_id) REFERENCES business(business_id),
    CONSTRAINT FK_user_id_review FOREIGN KEY(user_id) REFERENCES user(user_id)
)

/*Transforming data from a single JSON structure of staging to multiple columns of ODS*/
INSERT INTO review
SELECT  
    parse_json($1):review_id, 
    parse_json($1):business_id, 
    parse_json($1):user_id,
    parse_json($1):cool, 
    parse_json($1):date,
    parse_json($1):funny,
    parse_json($1):stars,
    parse_json($1):text,
    parse_json($1):useful
FROM UD_DW.STAGING.yelp_review;

---CLIMATE DATA---
---Transforming Temeperature Data from Staging to ODS---
CREATE OR REPLACE TABLE temperature (
    temperature_id int PRIMARY KEY IDENTITY,
    temp_date DATE,
    temp_min INT,
    temp_max INT,
    normal_min float,
    normal_max float,
	CONSTRAINT FK_temp_date_review FOREIGN KEY(temp_date) REFERENCES review(review_date)
)

INSERT INTO temperature (temp_date, temp_min, temp_max, normal_min, normal_max)
SELECT 
try_to_date("temp_date", 'yyyymmdd') AS temp_date,
"min",
"max",
"normal_min",
"normal_max"
FROM UD_DW.STAGING.CLIMATE_TEMPERATURE;

---Transforming Temeperature Data from Staging to ODS---
CREATE OR REPLACE TABLE precipitation (
    precipitation_id int PRIMARY KEY IDENTITY,
    precipitation_date DATE,
    precipitation float,
    precipitation_normal float,
	CONSTRAINT FK_precipitation_date_review FOREIGN KEY(precipitation_date) REFERENCES review(review_date)
)

INSERT INTO precipitation (precipitation_date, precipitation, precipitation_normal)
SELECT 
try_to_date("precipitation_date", 'yyyymmdd') AS temp_date,
"precipitation",
"precipitation_normal"
FROM UD_DW.STAGING.CLIMATE_PRECIPITATION;