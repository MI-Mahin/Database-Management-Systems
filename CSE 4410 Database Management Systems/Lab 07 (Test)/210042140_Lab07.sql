SET SERVEROUTPUT ON

--Task 01
DECLARE
  v_set_name VARCHAR2(50) := 'Alpha';
BEGIN
  DBMS_OUTPUT.PUT_LINE ('The name of my set is: '|| v_set_name);
END;
/


--Tak 02
SELECT DISTINCT A.ACT_FIRSTNAME, A.ACT_LASTNAME
FROM ACTOR A
JOIN CASTS C ON A.ACT_ID = C.ACT_ID
JOIN MOVIE M ON C.MOV_ID = M.MOV_ID
WHERE UPPER(M.MOV_TITLE) LIKE '%' || UPPER(A.ACT_FIRSTNAME) || '%' AND UPPER(M.MOV_TITLE) LIKE '%' || UPPER(A.ACT_LASTNAME) || '%';


--Task 03
SELECT DISTINCT G.GEN_TITLE AS Dominated_Genre
FROM GENRES G
JOIN MTYPE MT ON G.GEN_ID = MT.GEN_ID
JOIN MOVIE M ON MT.MOV_ID = M.MOV_ID
JOIN CASTS C ON M.MOV_ID = C.MOV_ID
JOIN ACTOR A ON C.ACT_ID = A.ACT_ID
WHERE A.ACT_GENDER = 'M';


--Task 04
CREATE OR REPLACE PROCEDURE CalculateMovieTime(p_movie_title IN VARCHAR2) IS
    v_total_duration NUMBER;
    v_total_hours NUMBER;
    v_total_minutes NUMBER;
    v_intermission_count NUMBER := 0;
    v_remaining_duration NUMBER;
    v_intermission_duration NUMBER := 15;
BEGIN
    SELECT MOV_TIME INTO v_total_duration
    FROM MOVIE
    WHERE UPPER(MOV_TITLE) = UPPER(p_movie_title);

    IF v_total_duration IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Movie with title ' || p_movie_title || ' not found.');
        RETURN;
    END IF;

    v_total_hours := TRUNC(v_total_duration / 60);
    v_total_minutes := v_total_duration - (v_total_hours * 60);

    IF v_total_duration > 30 THEN
        v_intermission_count := TRUNC(v_total_duration / 70);
        v_remaining_duration := v_total_duration - (v_intermission_count * 70);
        IF v_remaining_duration > 30 THEN
            v_intermission_count := v_intermission_count + 1;
        END IF;
    END IF;

    v_total_duration := v_total_duration + (v_intermission_count * v_intermission_duration);

    v_total_hours := TRUNC(v_total_duration / 60);
    v_total_minutes := v_total_duration - (v_total_hours * 60);

    DBMS_OUTPUT.PUT_LINE('Total Duration: ' || v_total_hours || ' Hour(s) ' || v_total_minutes || ' Minute(s)');
    DBMS_OUTPUT.PUT_LINE('Intermission Count: ' || v_intermission_count);
END CalculateMovieTime;
/

BEGIN
    CalculateMovieTime('Lawrence of Arabia'); --Checking for this movie
END;
/


--Task 05
CREATE OR REPLACE TRIGGER CheckGenreRating
BEFORE INSERT ON RATING
FOR EACH ROW
DECLARE
    v_genre_count NUMBER;
    v_avg_rating NUMBER;
BEGIN
    SELECT COUNT(DISTINCT GEN_ID)
    INTO v_genre_count
    FROM MTYPE M
    WHERE M.MOV_ID = :NEW.MOV_ID
      AND M.GEN_ID NOT IN (SELECT GEN_ID FROM RATING R JOIN MOVIE M2 ON R.MOV_ID = M2.MOV_ID WHERE R.REV_ID = :NEW.REV_ID);

    IF v_genre_count = 0 THEN
        SELECT AVG(R.REV_STARS)
        INTO v_avg_rating
        FROM RATING R
        WHERE R.MOV_ID IN (SELECT MOV_ID FROM MTYPE M WHERE M.GEN_ID = (SELECT GEN_ID FROM MTYPE WHERE MOV_ID = :NEW.MOV_ID))
          AND R.REV_ID != :NEW.REV_ID;

        DBMS_OUTPUT.PUT_LINE('Average Rating of the Genre by All Reviewers: ' || TO_CHAR(v_avg_rating));
    ELSE
        SELECT AVG(R.REV_STARS)
        INTO v_avg_rating
        FROM RATING R
        WHERE R.MOV_ID IN (SELECT MOV_ID FROM MTYPE M WHERE M.GEN_ID = (SELECT GEN_ID FROM MTYPE WHERE MOV_ID = :NEW.MOV_ID))
          AND R.REV_ID = :NEW.REV_ID
          AND R.MOV_ID != :NEW.MOV_ID;

        DBMS_OUTPUT.PUT_LINE('Average Rating of the Genre by the Reviewer: ' || TO_CHAR(v_avg_rating));
    END IF;
END;
/


--Task 06

