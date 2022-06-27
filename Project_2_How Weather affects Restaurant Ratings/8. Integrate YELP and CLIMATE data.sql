CREATE OR REPLACE VIEW yelp_weather AS
SELECT * FROM
review r
INNER JOIN temperature t
ON r.review_date = t.temp_date
INNER JOIN precipitation p
ON r.review_date = p.precipitation_date;