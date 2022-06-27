CREATE table Education (
Degree_ID SERIAL primary key,
Degree varchar(50)
);

CREATE table Employee (
Employee_ID varchar(6) primary key,
Employee_Name varchar(50),
Employee_Email varchar(50) UNIQUE,
Hire_Date DATE NOT NULL,
Degree_ID int REFERENCES Education(Degree_ID)
);

CREATE table Job (
Job_ID SERIAL primary key,
Job_Title varchar(50)
);

CREATE table Salary (
Salary_ID SERIAL primary key,
Salary INT
);

CREATE table Department (
Department_ID SERIAL primary key,
Department varchar(50)
);

CREATE table State (
State_ID SERIAL primary key,
State char(2)
);

CREATE table City (
City_ID SERIAL primary key,
City varchar(50),
State_ID int REFERENCES State(State_ID)
);

CREATE table Location (
Location_ID SERIAL primary key,
Location varchar(50)
);

CREATE table Address (
Address_ID SERIAL primary key,
Address varchar(50),
City_ID int REFERENCES City(City_ID),
Location_ID int REFERENCES Location(Location_ID)
);

CREATE table Employee_Details (
Employee_ID varchar(6) REFERENCES Employee(Employee_ID),
Job_ID int REFERENCES Job(Job_ID),
Salary_ID int REFERENCES Salary(Salary_ID),
Department_ID int REFERENCES Department(Department_ID),
Manager_ID varchar(6) REFERENCES Employee(Employee_ID),
Start_Date DATE,
End_Date DATE,
Address_ID int REFERENCES Address(Address_ID),
primary key(Employee_ID, Job_ID)
);