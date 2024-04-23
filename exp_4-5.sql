USE student;

-- Experiment 4

-- Find all departments where the total salary is greater than the average of the total salary at all departments
SELECT dept_name, SUM(salary) AS total_salary FROM instructor GROUP BY dept_name HAVING SUM(salary) > (SELECT AVG(total_salary) FROM (SELECT SUM(salary) AS total_salary FROM instructor GROUP BY dept_name) AS avg_salary);

--  List the names of instructors along with the course ID of the courses that they taught
SELECT i.name AS instructor_name, t.course_id FROM instructor i JOIN teaches t ON i.ID = t.ID;

-- List the names of instructors along with the course ID of the courses that they taught. In case, an instructor teaches no courses keep the course ID as null.
SELECT i.name AS instructor_name, t.course_id FROM instructor i LEFT JOIN teaches t ON i.ID = t.ID;

--  Create a view of instructors without their salary called faculty
CREATE VIEW faculty AS SELECT ID, name, dept_name FROM instructor;
SELECT * FROM faculty;

--  Give select privileges on the view faculty to the new user
CREATE USER new_user@localhost IDENTIFIED BY "1234";
GRANT SELECT ON faculty TO new_user@localhost;

-- Experiment 5

-- Create a view of instructors without their salary called faculty
CREATE VIEW faculty1 AS SELECT ID, name, dept_name FROM instructor;
SELECT * FROM faculty1;

-- Create a view of department salary totals
CREATE VIEW department_salary_totals AS SELECT dept_name, SUM(salary) AS total_salary FROM instructor GROUP BY dept_name;
SELECT * FROM department_salary_totals;

-- Create a role of student
CREATE ROLE 'student';

-- Give select privileges on the view faculty to the role student.
GRANT SELECT ON faculty TO student;

-- Create a new user and assign her the role of student.
CREATE USER guru@localhost IDENTIFIED BY '1234';
GRANT student TO guru@localhost;

-- Login as this new user and find all instructors in the Biology department.
GRANT ALL PRIVILEGES ON student.* TO guru@localhost;
-- SELECT * FROM faculty WHERE dept_name = 'Biology';

-- Revoke privileges of the new user
REVOKE student FROM guru@localhost;

-- Remove the role of student.
DROP ROLE student;

-- Give select privileges on the view faculty to the new user.
GRANT SELECT ON faculty TO guru@localhost;

-- Login as this new user and find all instructors in the finance department

-- Login again as root user

-- Create table teaches2 with same columns as teaches but with additional constraint that that semester is one of fall, winter, spring or summer.
CREATE TABLE teaches2 (
  ID INT NOT NULL,
  course_id VARCHAR(255) NOT NULL,
  sec_id INT NOT NULL,
  semester VARCHAR(255) NOT NULL CHECK (semester IN ('Fall', 'Winter', 'Spring', 'Summer')),
  year INT NOT NULL,
  FOREIGN KEY (ID) REFERENCES instructor(ID)
);

-- Create index ID column of teaches. Compare the difference in time to obtain query results with or without index. 
CREATE INDEX idx_ID ON teaches (ID);

-- Drop the index to free up the space.
DROP INDEX idx_ID ON teaches;

