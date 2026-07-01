{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(TRY_CAST(spid AS NUMBER(38,0)), -1) AS spid,

    COALESCE(TRY_CAST(costcenterkey AS NUMBER(38,0)), -1) AS costcenterkey,

    COALESCE(NULLIF(TRIM(purchasinggroupkey), ''), 'UNKNOWN') AS purchasinggroupkey,

    COALESCE(TRY_CAST(activeflag AS NUMBER(38,0)), 0) AS activeflag,

    COALESCE(TRY_CAST(departmentkey AS NUMBER(38,0)), -1) AS departmentkey,

    COALESCE(TRY_CAST(divisionkey AS NUMBER(38,0)), -1) AS divisionkey,

    COALESCE(NULLIF(TRIM(departmentname), ''), 'UNKNOWN') AS departmentname,

    COALESCE(NULLIF(TRIM(departmenthead), ''), 'UNKNOWN') AS departmenthead,

    COALESCE(
        TRY_TO_DATE(createddate, 'DD-MM-YYYY HH24:MI'),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'department') }}