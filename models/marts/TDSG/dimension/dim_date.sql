{{
    config(
        materialized='table'
    )
}}

WITH calendar AS (
    SELECT
        DATEADD(
            DAY,
            ROW_NUMBER() OVER (ORDER BY SEQ4()) - 1,
            TO_DATE('2023-01-01')
        ) AS full_date
    FROM TABLE(GENERATOR(ROWCOUNT => 3000))
),

holiday_flag AS (
    SELECT
        c.full_date,
        h.holidaydate
    FROM calendar AS c
    LEFT JOIN {{ ref('stg_holidaycalendar') }} AS h
        ON c.full_date = h.holidaydate
)
SELECT
    full_date AS fulldate,
    TO_NUMBER(TO_CHAR(full_date, 'YYYYMMDD')) AS datekey,
    YEAR(full_date) AS year,
    MONTH(full_date) AS month,
    MONTHNAME(full_date) AS monthname,
    'Q' || QUARTER(full_date) AS quarter,
    CASE
        WHEN DAYOFWEEKISO(full_date) IN (6, 7)
            THEN 'Y'
        ELSE 'N'
    END AS isweekend,
    CASE
        WHEN holidaydate IS NOT NULL
            THEN 'Y'
        ELSE 'N'
    END AS isholiday,
    CASE
        WHEN
            DAYOFWEEKISO(full_date) IN (6, 7)
            OR holidaydate IS NOT NULL
            THEN 'N'
        ELSE 'Y'
    END AS isworkingday
FROM holiday_flag
