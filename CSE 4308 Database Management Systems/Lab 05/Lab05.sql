--1
SELECT customer_name, customer_city
FROM customer
WHERE customer_name IN (
    SELECT DISTINCT B.customer_name
    FROM borrower B
    WHERE B.customer_name NOT IN (
        SELECT DISTINCT D.customer_name
        FROM depositor D
    )
);


--2
SELECT DISTINCT customer_name
FROM customer
WHERE customer_name IN (
    SELECT DISTINCT customer_name
    FROM depositor
) AND customer_name IN (
    SELECT DISTINCT customer_name
    FROM borrower
);


--3
SELECT INITCAP(TO_CHAR(TO_DATE(EXTRACT(MONTH FROM ACC_OPENING_DATE),'MM'), 'month')) AS MONTH,
COUNT(*) AS COUNT
FROM ACCOUNT
GROUP BY EXTRACT(MONTH FROM ACC_OPENING_DATE)
ORDER BY COUNT DESC;


--4
SELECT
    ABS(MONTHS_BETWEEN( (
        SELECT
            MAX(ACC_OPENING_DATE)
        FROM
            ACCOUNT
        WHERE
            ACCOUNT_NUMBER IN (
                SELECT
                    ACCOUNT_NUMBER
                FROM
                    DEPOSITOR
                WHERE
                    CUSTOMER_NAME = 'Smith'
            )
    ), (
        SELECT
            MAX(LOAN_DATE)
        FROM
            LOAN
        WHERE
            LOAN_NUMBER IN (
                SELECT
                    LOAN_NUMBER
                FROM
                    BORROWER
                WHERE
                    CUSTOMER_NAME = 'Smith'
            )
    ) )) AS MONTH
FROM
    DUAL;



--5
SELECT BRANCH_NAME, AVG(AMOUNT) AS AVG_LOAN_AMOUNT
FROM LOAN 
WHERE BRANCH_NAME IN (
    SELECT BRANCH_NAME
    FROM BRANCH
    WHERE BRANCH_CITY NOT LIKE '%a%'
    AND BRANCH_NAME NOT LIKE '%Horses%'
)
GROUP BY BRANCH_NAME;


--6
SELECT CUSTOMER_NAME, ACCOUNT_NUMBER
FROM depositor
WHERE ACCOUNT_NUMBER IN (
    SELECT ACCOUNT_NUMBER
    FROM ACCOUNT
    WHERE BALANCE = (
        SELECT MAX(BALANCE)
        FROM ACCOUNT
    )
)
;


--7
SELECT
    BRANCH_CITY,
    AVG(AMOUNT)
FROM
    LOAN,
    BRANCH
WHERE
    LOAN.BRANCH_NAME = BRANCH.BRANCH_NAME
GROUP BY
    BRANCH_CITY
HAVING
    AVG(AMOUNT) > 1500;




--8
SELECT
    CUSTOMER_NAME
    || ' Eligible' AS CUSTOMER_NAME
FROM
    DEPOSITOR
WHERE
    ACCOUNT_NUMBER IN (
        SELECT
            ACCOUNT_NUMBER
        FROM
            ACCOUNT
        WHERE
            BALANCE >= (
                SELECT
                    SUM(AMOUNT)
                FROM
                    LOAN
                WHERE
                    LOAN.BRANCH_NAME = ACCOUNT.BRANCH_NAME
                    AND LOAN.LOAN_NUMBER IN (
                        SELECT
                            LOAN_NUMBER
                        FROM
                            BORROWER
                        WHERE
                            BORROWER.CUSTOMER_NAME = DEPOSITOR.CUSTOMER_NAME
                    )
            )
    );




--9
SELECT
    BRANCH_NAME,
    CASE
        WHEN TOTAL_BALANCE > (AVG_TOTAL_BALANCE + 500) THEN
            'ELITE'
        WHEN TOTAL_BALANCE BETWEEN (AVG_TOTAL_BALANCE + 500) AND (AVG_TOTAL_BALANCE - 500) THEN
            'MODERATE'
        ELSE
            'POOR'
    END AS BRANCH_STATUS
FROM
    (
        SELECT
            BRANCH_NAME,
            SUM(BALANCE) AS TOTAL_BALANCE,
            AVG(BALANCE) AS AVG_TOTAL_BALANCE
        FROM
            ACCOUNT
        GROUP BY
            BRANCH_NAME
    );




--10
SELECT branch_name, branch_city from branch
where branch_city in
(
    select customer_city from customer
    where customer_city not in
    (
        select customer_city from customer
        where customer_name in
        (
            select customer_name from depositor
        )
        or
        customer_name in
        (
            select customer_name from borrower
        )
    )
)
and branch_name in
(
    select branch_name from loan
    group by branch_name
    having count(*) > 0
)
and branch_name in
(
    select branch_name from account
    group by branch_name
    having count(*) > 0
);

--11
CREATE TABLE New_New_Customer AS
SELECT * FROM customer
where customer_name = 'dog';


--12
INSERT INTO New_New_Customer
SELECT * FROM customer
where customer_name in
(
    select customer_name from depositor
)
or
customer_name in
(
    select customer_name from borrower
);


--13
ALTER TABLE New_New_Customer
ADD status VARCHAR2(15);


--14
UPDATE CUSTOMER_NEW
SET
    STATUS = (
        SELECT CASE WHEN TOTAL_BALANCE > TOTAL_LOAN THEN 'IN SAVINGS' WHEN TOTAL_BALANCE < TOTAL_LOAN THEN 'IN LOAN' ELSE 'IN BREAKEVEN' END FROM ( SELECT CUSTOMER_NAME, SUM(BALANCE) AS TOTAL_BALANCE, SUM(AMOUNT) AS TOTAL_LOAN FROM ACCOUNT, LOAN WHERE ACCOUNT.BRANCH_NAME = LOAN.BRANCH_NAME AND ACCOUNT.ACCOUNT_NUMBER IN ( SELECT ACCOUNT_NUMBER FROM DEPOSITOR WHERE CUSTOMER_NAME = CUSTOMER_NEW.CUSTOMER_NAME ) AND LOAN.LOAN_NUMBER IN ( SELECT LOAN_NUMBER FROM BORROWER WHERE CUSTOMER_NAME = CUSTOMER_NEW.CUSTOMER_NAME ) GROUP BY CUSTOMER_NAME ) WHERE CUSTOMER_NAME = CUSTOMER_NEW.CUSTOMER_NAME
    );



--15
SELECT
    STATUS,
    COUNT(*) AS COUNT
FROM
    CUSTOMER_NEW
GROUP BY
    STATUS;













