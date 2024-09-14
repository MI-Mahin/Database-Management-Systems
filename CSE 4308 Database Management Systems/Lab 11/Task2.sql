CREATE OR REPLACE PROCEDURE TOP_RATINGS (
    N IN NUMBER
) IS
BEGIN
    FOR I IN (
        SELECT
            M.MOV_TITLE
        FROM
            MOVIE  M
            JOIN RATING R
            ON M.MOV_ID = R.MOV_ID
        ORDER BY
            R.REV_STARS DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(I.MOV_TITLE);
    END LOOP;
END TOP_RATINGS;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Top 5 movies by rating:');
    TOP_RATINGS(5);
END;
/