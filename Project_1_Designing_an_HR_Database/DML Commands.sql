INSERT INTO Education (Degree)
SELECT DISTINCT(education_lvl)
FROM proj_stg;

INSERT INTO Employee(Employee_ID, Employee_Name, Employee_Email, Hire_Date, Degree_ID)
SELECT DISTINCT stg.emp_id, stg.emp_nm, stg.email, stg.hire_dt, edu.degree_id 
FROM proj_stg stg
INNER JOIN Education edu
ON stg.education_lvl = edu.Degree;

INSERT INTO Job (Job_Title)
SELECT DISTINCT(job_title)
FROM proj_stg;

INSERT INTO Salary (Salary)
SELECT DISTINCT(salary)
FROM proj_stg;

INSERT INTO Department (Department)
SELECT DISTINCT(department_nm)
FROM proj_stg;

INSERT INTO State (State)
SELECT DISTINCT(state)
FROM proj_stg;

INSERT INTO Location (Location)
SELECT DISTINCT(location)
FROM proj_stg;

INSERT INTO City(City, State_ID)
SELECT DISTINCT(stg.city), s.State_ID 
FROM proj_stg stg
INNER JOIN State s
ON stg.state = s.state;

INSERT INTO Address(address, city_id, location_id)
SELECT DISTINCT (stg.address), ct.city_id, loc.location_id
FROM proj_stg stg 
INNER JOIN City ct
ON stg.city = ct.City
INNER JOIN Location loc
ON stg.location = loc.location;


WITH employee_history AS(
    SELECT 
    e.Employee_ID, j.job_id, s.salary_id, d.Department_ID, 
    stg.manager, stg.start_dt, stg.end_dt, a.address_id
    FROM proj_stg stg 
    INNER JOIN Employee e
    ON stg.emp_id = e.Employee_ID
    INNER JOIN Job j
    ON stg.job_title = j.job_title
    INNER JOIN Salary s
    ON stg.salary = s.salary
    INNER JOIN Department d
    ON stg.department_nm = d.Department
    INNER JOIN Address a
    ON stg.address = a.Address
    INNER JOIN Education edu
    ON stg.education_lvl = edu.Degree),

manager_detail AS (
    SELECT DISTINCT stg2.Manager, stg.emp_id
    FROM proj_stg stg
    INNER JOIN proj_stg stg2
    ON stg.emp_nm = stg2.manager
)
INSERT INTO Employee_Details(Employee_ID, Job_ID, Salary_ID, Department_ID, Manager_ID, Start_Date, End_Date, Address_ID)
SELECT emp.Employee_ID, emp.job_id, emp.salary_id, emp.Department_ID, mgr.emp_id,  
    emp.start_dt, emp.end_dt, emp.address_id
FROM 
employee_history emp
INNER JOIN manager_detail mgr
ON mgr.manager = emp.manager;