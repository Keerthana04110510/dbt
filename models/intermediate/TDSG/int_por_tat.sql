{{
    config(
        materialized='table'
    )
}}

WITH por AS (
    SELECT *
    FROM {{ ref('int_por_enriched') }}

),
tat AS (
    SELECT
        p.porid,
        COUNT(*) AS tatdays
    FROM por p
    INNER JOIN {{ ref('dim_date') }} d
        ON d.fulldate BETWEEN
       TO_DATE(p.ringi_submitteddate)
   AND TO_DATE(p.podate)
    WHERE d.isworkingday = 'Y'
    GROUP BY p.porid
)
SELECT
    p.porid,
    p.porno,
    p.departmentid AS departmentkey,
    p.divisionkey,
    p.purchasinggroupid AS purchasinggroupkey,
    p.employeekey,
    p.datekey,
    p.totalamount_inr AS porvalue_inr,
    p.status,
    p.ringi_submitteddate AS submitteddate,
    p.pono,
    p.podate,
    COALESCE(t.tatdays,0) AS tatdays,
    CASE
        WHEN COALESCE(t.tatdays,0) <= 3
            THEN '0-3 Days'
        WHEN COALESCE(t.tatdays,0) <= 7
            THEN '4-7 Days'
        WHEN COALESCE(t.tatdays,0) <= 15
            THEN '8-15 Days'
        ELSE '>15 Days'
    END AS tatbucket,
    CASE
        WHEN p.pono IS NULL
            THEN 'N'
        ELSE 'Y'
    END AS isconvertedtopo,
    p.reviseno,
    p.option1,
    p.option2,
    p.isdeleted,
    p.ringiid,
    p.finalvendorid,
    p.ringino,
    p.ringistatus,
    p.ringivalue_inr,
    p.purchaserid,
    p.purchasername
FROM por p
LEFT JOIN tat t
ON p.porid = t.porid