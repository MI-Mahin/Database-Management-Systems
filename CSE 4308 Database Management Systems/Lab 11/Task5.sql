CREATE OR REPLACE FUNCTION MOST_FREQUENT_GENRE (
    START_DATE IN DATE,
    END_DATE IN DATE
) RETURN VARCHAR2 IS
    MOST_FREQUENT_GENRE_NAME VARCHAR2(50);
    MOVIE_COUNT              NUMBER;
BEGIN
    SELECT
        G.GEN_TITLE,
        COUNT(*) INTO MOST_FREQUENT_GENRE_NAME,
        MOVIE_COUNT
    FROM
        MOVIE  M
        JOIN GENRES G
        ON M.GEN_ID = G.GEN_ID
    WHERE
        M.MOV_RELEASEDATE BETWEEN START_DATE AND END_DATE
    GROUP BY
        G.GEN_TITLE
    ORDER BY
        MOVIE_COUNT DESC FETCH FIRST 1 ROW ONLY;
    RETURN MOST_FREQUENT_GENRE_NAME;
END MOST_FREQUENT_GENRE;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE(MOST_FREQUENT_GENRE(DATE '2019-01-01', DATE '2020-01-01'));
END;