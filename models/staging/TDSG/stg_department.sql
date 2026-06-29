{{
    config(
        materialized='table'
    )
}}

SELECT
    spid,
    costcenterkey,
    purchasinggroupkey,
    activeflag,
    CAST(departmentkey as int) AS departmentkey,
    CAST(divisionkey as int) AS divisionkey,
    COALESCE(TRIM(departmentname), 'unknown') AS departmentname,
    TRIM(departmenthead) AS departmenthead,
    TRY_TO_DATE(createddate, 'DD-MM-YYYY HH24:MI') AS createddate
FROM {{ source('tdsg_source','department') }}
