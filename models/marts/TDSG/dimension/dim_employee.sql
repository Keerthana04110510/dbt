{{
    config(
        materialized='table'
    )
}}

SELECT
    EMPLOYEEKEY,
    DEPARTMENTKEY,
    REPORTINGMANAGERKEY,
    EMPLOYEECODE,
    EMPLOYEENAME,
    EMPDESIGNATION,
    EMAIL,
    ISACTIVE,
    DBT_VALID_FROM AS EFFECTIVEFROM,
    DBT_VALID_TO AS EFFECTIVETO,
    CASE
        WHEN DBT_VALID_TO IS NULL
            THEN 'Y'
        ELSE 'N'
    END AS ISCURRENT

FROM {{ ref('snap_employee') }}
