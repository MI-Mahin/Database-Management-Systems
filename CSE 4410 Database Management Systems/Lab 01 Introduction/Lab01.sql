--1
SELECT name
FROM instructor
WHERE dept_name = 'Biology';

--2
SELECT course.course_id, course.title
FROM takes
JOIN course ON takes.course_id = course.course_id
WHERE takes.ID = '73492';



--3
SELECT DISTINCT student.name, student.dept_name
FROM student
JOIN takes ON student.ID = takes.ID
JOIN course ON takes.course_id = course.course_id
WHERE course.dept_name = 'Comp. Sci.';



--4
SELECT DISTINCT student.name
FROM student
JOIN takes ON student.ID = takes.ID
WHERE takes.course_id = 'CS-101' AND takes.semester = 'Spring' AND takes.year = '2018';



--5
SELECT name
FROM Student
WHERE ID IN (
SELECT ID
FROM (
        SELECT ID, RANK() OVER (ORDER BY COUNT(DISTINCT course_id) DESC) as rank
        FROM takes
        WHERE course_id LIKE 'CS%'
        GROUP BY ID
    )
    WHERE rank = 1
);


--6
SELECT name
FROM Student
WHERE ID IN (
Select takes.ID
From takes,teaches,instructor
Where takes.course_id = teaches.course_id AND teaches.ID = instructor.ID
Group By takes.ID
Having COUNT(distinct instructor.ID)>=3);


--7
SELECT * FROM 
(SELECT c.title, s.sec_id, COUNT(t.ID) AS enrollment_count
FROM course c JOIN section s ON c.course_id = s.course_id
LEFT JOIN takes t ON s.course_id = t.course_id AND s.sec_id = t.sec_id
GROUP BY s.sec_id, c.title
HAVING COUNT(t.ID) > 0
ORDER BY enrollment_count
)
WHERE ROWNUM = 1;



--8
Select Max(instructor.name) as name, Max(instructor.dept_name) as department, COUNT(NVL(student.ID,0)) as No_of_Student
From instructor,advisor,Student
Where advisor.s_id= student.ID AND advisor.i_id = instructor.ID
Group By instructor.ID;


--9
SELECT s.name, s.dept_name
FROM student s
WHERE s.ID IN 
(
    SELECT ID FROM takes t
    GROUP BY t.ID
    HAVING COUNT(*) > 
    (
        SELECT AVG(course_count)
        FROM 
        (
            SELECT COUNT(*) as course_count
            FROM takes tt
            GROUP BY tt.ID
        )
    )
);


--10
UPDATE Student
SET tot_cred = 0
WHERE ID IN (SELECT ID FROM Instructor);

INSERT INTO Student (ID, name, dept_name, tot_cred)
SELECT ID, name, dept_name, 0 AS tot_cred
FROM Instructor;



--11
DELETE FROM Student
WHERE ID IN (SELECT ID FROM Instructor);


--12
UPDATE Student
SET tot_cred = NVL
(
    (SELECT SUM(course.credits) AS credits
     FROM takes
     LEFT JOIN course ON takes.course_id = course.course_id
     WHERE takes.ID = Student.ID), 0
);

SELECT * FROM Student;


--13
UPDATE instructor
SET salary = 10000 * (
    SELECT COUNT(DISTINCT teaches.sec_id)
    FROM teaches
    WHERE teaches.ID = instructor.ID
    HAVING COUNT(DISTINCT teaches.sec_id)>2
);


--14
Create table grade_point
(
    grade varchar(2) primary key,
    point numeric(2,0) not null
);

INSERT INTO grade_point VALUES ('A', 10);
INSERT INTO grade_point VALUES ('B', 8);
INSERT INTO grade_point VALUES ('C', 6);
INSERT INTO grade_point VALUES ('D', 4);
INSERT INTO grade_point VALUES ('F', 0);

SELECT s.ID, s.name, s.dept_name, SUM(g.point * c.credits) / SUM(c.credits) as CPI
FROM student s, takes t, course c, grade_point g
WHERE s.ID = t.ID
AND t.course_id = c.course_id
AND t.grade = g.grade
GROUP BY s.ID, s.name, s.dept_name;