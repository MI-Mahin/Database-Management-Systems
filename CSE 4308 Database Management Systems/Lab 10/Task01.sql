SET SERVEROUTPUT ON SIZE 1000000;
SET VERIFY OFF;

--a--
BEGIN
DBMS_OUTPUT.PUT_LINE('Mahmudul Islam Mahin');
END;
/

--b--
DECLARE
ID VARCHAR2 (20);
BEGIN
ID := '&Student_Id';
DBMS_OUTPUT.PUT_LINE('Student Id Length: ' || LENGTH(ID));
END ;
/

--c--
DECLARE
Num1 NUMBER;
Num2 NUMBER;
Numsum NUMBER;
BEGIN
Num1 := '&Num1';
Num2 := '&Num2';
Numsum := Num1+ Num2;
DBMS_OUTPUT.PUT_LINE( 'Sum= ' || Numsum);
END ;
/

---d--
DECLARE
nowTime TIMESTAMP;
BEGIN
nowTime:= SYSTIMESTAMP;
DBMS_OUTPUT . PUT_LINE ('Current Time: ' || TO_CHAR ( nowTime, 'HH :MI:SS AM'));
END ;
/

--e--
DECLARE
Num1 NUMBER;
BEGIN
Num1 := '&Number';
IF MOD(num1,1) = 0
THEN DBMS_OUTPUT.PUT_LINE( Num1 || ' is a Whole Number');
ELSE
DBMS_OUTPUT.PUT_LINE( Num1 || ' is a Fraction');
END IF;
END ;
/

--f--
CREATE OR REPLACE
FUNCTION Check_Composite (num NUMBER)
RETURN BOOLEAN
IS
BEGIN
IF (num <= 1)
THEN RETURN FALSE;
END IF;
FOR i IN 2..ROUND(SQRT(num)) LOOP
        IF MOD(num, i) = 0 THEN
            RETURN TRUE;
        END IF;
    END LOOP;
RETURN FALSE;
END ;
/
-- Call it from an anonymous block
DECLARE
num NUMBER;
res BOOLEAN;
BEGIN
num:= '&number';
res:= Check_Composite(num);
IF res
THEN DBMS_OUTPUT.PUT_LINE(num || ' is Composite');
ELSE DBMS_OUTPUT.PUT_LINE(num || ' is Prime');
END IF;
END ;
/