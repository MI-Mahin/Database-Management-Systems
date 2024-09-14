CREATE OR REPLACE PROCEDURE REQUIRED_TIME (
    MOV_TITLE IN VARCHAR2
) IS
    TOTAL_TIME        NUMBER;
    INTERMISSION_TIME NUMBER := 15;
    REMAINING_TIME    NUMBER;
    HOURS             NUMBER;
    MINUTES           NUMBER;
BEGIN
    SELECT
        MOV_TIME INTO TOTAL_TIME
    FROM
        MOVIE
    WHERE
        MOV_TITLE = REQUIRED_TIME.MOV_TITLE;
    REMAINING_TIME := TOTAL_TIME;
    WHILE REMAINING_TIME > 70 LOOP
        REMAINING_TIME := REMAINING_TIME - 70;
        INTERMISSION_TIME := INTERMISSION_TIME + 15;
    END LOOP;

    HOURS := TRUNC(TOTAL_TIME / 60);
    MINUTES := TOTAL_TIME - (HOURS * 60);
    DBMS_OUTPUT.PUT_LINE('Total time: '
                         || HOURS
                         || ' hours '
                         || MINUTES
                         || ' minutes');
    DBMS_OUTPUT.PUT_LINE('Intermission time: '
                         || INTERMISSION_TIME
                         || ' minutes');
END REQUIRED_TIME;
/

DECLARE
    MOVIE_TITLE VARCHAR2(50);
BEGIN
    MOVIE_TITLE := '&MOVIE_TITLE';
    REQUIRED_TIME(MOVIE_TITLE);
END;
/