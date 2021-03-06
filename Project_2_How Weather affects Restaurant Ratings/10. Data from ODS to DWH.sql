--Database: UD_DW---
--Schema: DWH---
--Worksheet : UD_DW.DWH--

CREATE OR REPLACE TABLE dim_location (
    location_id int PRIMARY KEY IDENTITY,
    business_id varchar(255),
    address varchar(255), 
    city varchar(50),
    state varchar(50),
    postal_code varchar(25), 
    latitude float,
    longitude float
);

INSERT INTO dim_location(business_id, name, address, city, state, postal_code, latitude, longitude)
SELECT
    business_id,
    address, 
    city,
    state,
    postal_code, 
    latitude,
    longitude
FROM 
UD_DW.ODS.business;
 
CREATE OR REPLACE TABLE dim_business (
    business_id varchar(255) PRIMARY KEY,
	name varchar(255),
    stars float, 
    location_id int
)

INSERT INTO dim_business
SELECT
    b.business_id,
	b.name,
    b.stars,
    l.location_id
FROM 
UD_DW.ODS.business b
RIGHT JOIN dim_location l
ON b.business_id = l.business_id;


CREATE OR REPLACE TABLE dim_user (
    user_id varchar(255) PRIMARY KEY,
    name varchar(255)
);

INSERT INTO dim_user
SELECT
    user_id,
    name
FROM 
UD_DW.ODS.user


CREATE OR REPLACE TABLE dim_weather (
    date_id int PRIMARY KEY IDENTITY,
    weather_date DATE,
    temp_min INT,
    temp_max INT,
    normal_min float,
    normal_max float,
    precipitation float,
    precipitation_normal float
)

INSERT INTO dim_weather (weather_date, temp_min, temp_max, normal_min, normal_max, precipitation, precipitation_normal)
SELECT 
t.temp_date, 
t.temp_min, 
t.temp_max, 
t.normal_min, 
t.normal_max, 
p.precipitation, 
p.precipitation_normal
FROM UD_DW.ODS.temperature t
INNER JOIN UD_DW.ODS.precipitation p 
ON t.temperature_id = p.precipitation_id;


CREATE OR REPLACE TABLE fact_review (
    review_id varchar(255) PRIMARY KEY, 
    business_id varchar(255), 
    user_id varchar(255),
    date_id int,
    location_id int, 
    stars float,
    review_text text,
    CONSTRAINT FK_business_id_dim_business FOREIGN KEY(business_id) REFERENCES dim_business(business_id),
    CONSTRAINT FK_location_id_dim_location FOREIGN KEY(location_id) REFERENCES dim_location(location_id),
    CONSTRAINT FK_user_id_dim_user FOREIGN KEY(user_id) REFERENCES dim_user(user_id),
    CONSTRAINT FK_date_id_dim_weather FOREIGN KEY(date_id) REFERENCES dim_weather(date_id)
)

INSERT INTO fact_review
SELECT 
r.review_id,
r.business_id,
r.user_id,
w.date_id,
l.location_id,
r.stars,
r.review_text
FROM
UD_DW.ODS.review r
INNER JOIN dim_location l
ON r.business_id = l.business_id
INNER JOIN dim_weather w
ON r.review_date = w.weather_date;