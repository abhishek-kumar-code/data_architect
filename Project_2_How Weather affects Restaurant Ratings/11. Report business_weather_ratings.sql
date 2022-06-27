SELECT 
b.business_id, b.name, 
w.weather_date, w.temp_min, w.temp_max, w.normal_min, w.normal_max, w.precipitation, w.precipitation_normal,
f.stars  
FROM
fact_review f
INNER JOIN dim_weather w
ON f.date_id = w.date_id
INNER JOIN dim_business b
ON f.business_id = b.business_id;