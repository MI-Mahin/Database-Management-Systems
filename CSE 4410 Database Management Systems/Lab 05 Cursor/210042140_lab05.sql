--TASK 1
DECLARE
  
  CURSOR department_cursor IS
    SELECT dept_name, budget
    FROM department
    WHERE budget > 99999
    FOR UPDATE;

  department_rec department_cursor%ROWTYPE;

  unaffected_departments NUMBER := 0;

BEGIN
  
  OPEN department_cursor;

  LOOP
    
    FETCH department_cursor INTO department_rec;

    EXIT WHEN department_cursor%NOTFOUND;

    UPDATE department
    SET budget = department_rec.budget * 0.9
    WHERE CURRENT OF department_cursor;

    unaffected_departments := unaffected_departments + 1;
  END LOOP;

  CLOSE department_cursor;

  DBMS_OUTPUT.PUT_LINE('Number of departments unaffected: ' || unaffected_departments);
  
END;
/

--TASK 2
CREATE OR REPLACE PROCEDURE show_instructors(p_day VARCHAR2, p_start_hour NUMBER, p_end_hour NUMBER) 
AS
BEGIN
    FOR instructor_rec IN (
        SELECT DISTINCT i.name
        FROM instructor i
        JOIN teaches t ON i.ID = t.ID
        JOIN section s ON t.course_id = s.course_id AND t.sec_id = s.sec_id
        JOIN time_slot ts ON s.time_slot_id = ts.time_slot_id
        WHERE ts.day = p_day
        AND (ts.start_hr < p_end_hour OR (ts.start_hr = p_end_hour AND ts.start_min = 0))
        AND (ts.end_hr > p_start_hour OR (ts.end_hr = p_start_hour AND ts.end_min = 0))
    ) 
    LOOP
        DBMS_OUTPUT.PUT_LINE('Instructor name: ' || instructor_rec.name);
    END LOOP;
END;
/

DECLARE
    day VARCHAR2(10);
    start_hr NUMBER;
    end_hr NUMBER;

BEGIN
    day:= '&day';
    start_hr:= &start_hour;
    end_hr:= &end_hour;

    show_instructors(day, start_hr, end_hr);
    
END;
/
--TASK 3
CREATE OR REPLACE PROCEDURE top_students(N IN NUMBER) AS
    counter NUMBER := 0;
BEGIN
    FOR student_record IN (
        SELECT s.ID, s.name, s.dept_name, COUNT(t.course_id) AS num_courses
        FROM student s
        LEFT JOIN takes t ON s.ID = t.ID
        GROUP BY s.ID, s.name, s.dept_name
        ORDER BY num_courses DESC
    ) 
    LOOP
        counter := counter + 1;
        EXIT WHEN counter > N;
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || student_record.ID || ', Name: ' || student_record.name || ', Department: ' || student_record.dept_name || ', Num Courses: ' || student_record.num_courses);
    END LOOP;
END;
/

DECLARE
    student_count NUMBER;

BEGIN
    student_count:= &student_count;
    top_students(student_count);
END;
/
--TASK 4
DECLARE

  new_student_id VARCHAR2(5);
  new_student_name VARCHAR2(20) := 'Jane Doe';
  new_student_dept_name VARCHAR2(20);
  max_existing_id VARCHAR2(5);

  CURSOR lowest_dept_cursor IS
    SELECT dept_name
    FROM (
      SELECT dept_name, COUNT(*) AS num_students
      FROM student
      GROUP BY dept_name
      ORDER BY num_students
      )
      WHERE ROWNUM = 1;

BEGIN

  OPEN lowest_dept_cursor;

  FETCH lowest_dept_cursor INTO new_student_dept_name;

  CLOSE lowest_dept_cursor;

  SELECT MAX(ID) INTO max_existing_id
  FROM student
  WHERE dept_name = new_student_dept_name;

  new_student_id := TO_CHAR(TO_NUMBER(max_existing_id) + 1);

  INSERT INTO student (ID, name, dept_name, tot_cred)
  VALUES (new_student_id, new_student_name, new_student_dept_name, 0);

  DBMS_OUTPUT.PUT_LINE('New student ' || new_student_name || ' inserted with ID ' || new_student_id ||
                       ' in department ' || new_student_dept_name);


END;
/


--TASK 5
CREATE OR REPLACE PROCEDURE assign_advisor AS
    std_id student.ID%TYPE;
    std_name student.name%TYPE;
    std_dept student.dept_name%TYPE;
    adv_id instructor.ID%TYPE;
    adv_name instructor.name%TYPE;
    num_students_advised NUMBER;

BEGIN

    FOR std_rec IN (
        SELECT s.ID, s.name, s.dept_name
        FROM student s
        WHERE s.ID NOT IN (SELECT a.s_ID FROM advisor a)
    )
    LOOP
        std_id := std_rec.ID;
        std_name := std_rec.name;
        std_dept := std_rec.dept_name;

        SELECT ID, name INTO adv_id, adv_name FROM(
            SELECT i.ID, i.name, COUNT(a.s_ID)
            FROM instructor i
            LEFT JOIN advisor a ON i.ID = a.i_ID
            WHERE i.dept_name = std_dept
            GROUP BY i.ID, i.name
            ORDER BY COUNT(a.s_ID) ASC
        )
        WHERE ROWNUM = 1;

        INSERT INTO advisor (s_ID, i_ID) VALUES (std_id, adv_id);

        SELECT COUNT(s_ID) AS num_advised into num_students_advised
        FROM advisor
        GROUP BY i_ID
        HAVING i_ID= adv_id;

        DBMS_OUTPUT.PUT_LINE('Student: ' || std_name || ', Advisor: ' || adv_name || ', Students advised by Advisor: ' || num_students_advised);
    END LOOP;

END;
/

BEGIN
    assign_advisor;
END;
/
