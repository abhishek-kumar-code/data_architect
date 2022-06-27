--Return a list of employees with Job Titles and Department Names
SELECT e.Employee_Name, j.Job_Title, d.Department
FROM employee_details ed
JOIN employee e 
ON ed.Employee_ID = e.Employee_ID 
JOIN job j 
ON ed.Job_ID = j.Job_ID
JOIN Department d 
ON ed.Department_ID = d.Department_ID;

--Insert Web Programmer as a new job title
INSERT INTO Job (job_title)
VALUES ('Web Programmer');

--Correct the job title from web programmer to web developer
UPDATE Job
SET job_title = 'Web Developer'
WHERE job_title = 'Web Programmer';

--Delete the job title Web Developer from the database
DELETE FROM Job
WHERE job_title = 'Web Developer';

--How many employees are in each department?
SELECT d.Department, COUNT(e.Employee_ID)
FROM employee_details ed
JOIN employee e 
ON ed.Employee_ID = e.Employee_ID 
JOIN job j 
ON ed.Job_ID = j.Job_ID
JOIN Department d 
ON ed.Department_ID = d.Department_ID
GROUP BY d.Department;

--Write a query that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) for employee Toni Lembeck.

SELECT e.Employee_Name, j.Job_Title, d.Department, em.Employee_Name AS Manager_Name, ed.start_date, ed.end_date
FROM employee_details ed
JOIN employee e 
ON ed.Employee_ID = e.Employee_ID
JOIN employee em
ON em.Employee_ID = ed.Manager_ID
JOIN job j 
ON ed.Job_ID = j.Job_ID
JOIN Department d 
ON ed.Department_ID = d.Department_ID
WHERE e.Employee_Name = 'Toni Lembeck';


--Create a view that returns all employee attributes; results should resemble initial Excel file

CREATE VIEW hr_dataset AS
SELECT e.Employee_ID, e.Employee_Name, e.Employee_Email, e.Hire_Date, j.Job_Title, sal.Salary, d.Department, em.Employee_Name AS manager_name, ed.start_date, ed.end_date, l.Location, a.Address, c.City, s.State, edu.Degree
FROM employee_details ed
JOIN employee e 
ON ed.Employee_ID = e.Employee_ID  
JOIN employee em
ON em.Employee_ID = ed.Manager_ID
JOIN job j 
ON ed.Job_ID = j.Job_ID
INNER JOIN Salary sal
ON ed.salary_id = sal.salary_id
JOIN Department d 
ON ed.Department_ID = d.Department_ID
JOIN Address a
ON ed.Address_ID = a.Address_ID
JOIN Education edu
ON edu.Degree_ID = e.Degree_ID
JOIN Location l
ON a.Location_ID = l.Location_ID
JOIN City c
ON a.City_ID = c.City_ID
JOIN State s
ON c.State_ID = s.State_ID;

---
---Create a stored procedure with parameters that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) when given an employee name.

CREATE OR REPLACE FUNCTION select_employee(name text) RETURNS refcursor AS $$
    DECLARE
      ref refcursor;
    BEGIN
      OPEN ref FOR 
        SELECT e.Employee_Name, j.Job_Title, d.Department, 
        em.Employee_Name AS manager_name, ed.start_date, ed.end_date
        FROM employee_details ed
        JOIN employee e 
        ON ed.Employee_ID = e.Employee_ID
        JOIN employee em
        ON em.Employee_ID = ed.Manager_ID
        JOIN job j 
        ON ed.Job_ID = j.Job_ID
        JOIN Department d 
        ON ed.Department_ID = d.Department_ID
        WHERE e.Employee_Name = name;
        RETURN ref;
    END;
    $$ LANGUAGE plpgsql;

SELECT select_employee('Toni Lembeck');

 -- Start a transaction
BEGIN;
SELECT select_employee('Toni Lembeck');
FETCH ALL IN "<unnamed portal 10>";
COMMIT;

--------
--Implement user security on the restricted salary attribute.

CREATE USER NoMgr;

GRANT SELECT 
(Employee_ID,
Job_ID,
Department_ID,
Manager_ID,
Start_Date,
End_Date,
Address_ID,
Degree_ID)
ON Employee_Details
TO NoMgr;