--TASK 01
CREATE SEQUENCE Biology_Seq 
START WITH 1 
INCREMENT BY 1;

CREATE SEQUENCE CompSci_Seq 
START WITH 1 
INCREMENT BY 1;

CREATE SEQUENCE ElecEng_Seq 
START WITH 1 
INCREMENT BY 1;

CREATE SEQUENCE Finance_Seq 
START WITH 1 
INCREMENT BY 1;

CREATE SEQUENCE History_Seq
 START WITH 1 
INCREMENT BY 1;

CREATE SEQUENCE Music_Seq
 START WITH 1 
 INCREMENT BY 1;

CREATE SEQUENCE Physics_Seq 
START WITH 1 
INCREMENT BY 1;

CREATE OR REPLACE FUNCTION GenerateStudentID(departmentName VARCHAR2) 
RETURN VARCHAR2 
AS
     departmentCode NUMBER;
     sequenceNumber NUMBER;
     studentID VARCHAR2(05);
     
BEGIN
    IF departmentName = 'Biology' THEN
        departmentCode := 1;
        SELECT Biology_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSIF departmentName = 'Comp. Sci.' THEN
        departmentCode := 2;
        SELECT CompSci_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSIF departmentName = 'Elec. Eng.' THEN
        departmentCode := 3;
        SELECT ElecEng_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSIF departmentName = 'Finance' THEN
        departmentCode := 4;
        SELECT Finance_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSIF departmentName = 'History' THEN
        departmentCode := 5;
        SELECT History_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSIF departmentName = 'Music' THEN
        departmentCode := 6;
        SELECT Music_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSIF departmentName = 'Physics' THEN
        departmentCode := 7;
        SELECT Physics_Seq.NEXTVAL INTO sequenceNumber FROM dual;
    ELSE
        departmentCode := 0; 
        sequenceNumber := 0;
    END IF;

    studentID := departmentCode || LPAD(TO_CHAR(sequenceNumber), 4, '0');

    RETURN studentID;
END;
/
DECLARE
    result VARCHAR2(5);
BEGIN
    result := GenerateStudentID('Physics'); 
    DBMS_OUTPUT.PUT_LINE('Student ID: ' || result);
END;
/



--TASK 02
CREATE OR REPLACE PROCEDURE UPDATE_ALL_STUDENT_ID IS
BEGIN
    UPDATE STUDENT
    SET
        ID = GENERATE_SID(
            DEPT_NAME
        );
    DBMS_OUTPUT.PUT_LINE('All student ID updated successfully.');
END UPDATE_ALL_STUDENT_ID;
/

BEGIN
    UPDATE_ALL_STUDENT_ID;
END;
/

--TASK 03
CREATE OR REPLACE TRIGGER generate_student_id
BEFORE INSERT ON Student
FOR EACH ROW
BEGIN
    :NEW.ID := GenerateStudentID(:NEW.Dept_Name);
END;
/

INSERT INTO Student (ID, Name, Dept_Name, Tot_Cred)
VALUES ('00000', 'Mahin', 'Comp. Sci.', 170);

--TASK 04
CREATE OR REPLACE TRIGGER update_tot_cred
AFTER INSERT ON takes
FOR EACH ROW
BEGIN
    UPDATE Student
    SET Tot_Cred = Tot_Cred + (SELECT Credits FROM Course WHERE Course_ID = :NEW.Course_ID)
    WHERE ID = :NEW.Student_ID;
END;
/


--TASK 05