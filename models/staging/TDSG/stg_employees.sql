{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(TRY_CAST(employeekey AS NUMBER(38,0)), -1) AS employeekey,

    COALESCE(TRY_CAST(departmentkey AS NUMBER(38,0)), -1) AS departmentkey,

    COALESCE(TRY_CAST(reportingmanagerkey AS NUMBER(38,0)), -1) AS reportingmanagerkey,

    COALESCE(NULLIF(TRIM(plantkey), ''), 'UNKNOWN') AS plantkey,

    COALESCE(NULLIF(TRIM(employeecode), ''), 'UNKNOWN') AS employeecode,

    COALESCE(NULLIF(TRIM(costcenter), ''), 'UNKNOWN') AS costcenter,

    COALESCE(TRY_CAST(isadmin AS NUMBER(38,0)), 0) AS isadmin,

    COALESCE(NULLIF(TRIM(email), ''), 'UNKNOWN') AS email,

    COALESCE(NULLIF(TRIM(empdesignation), ''), 'UNKNOWN') AS empdesignation,

    COALESCE(TRY_CAST(isvendorsync AS NUMBER(38,0)), 0) AS isvendorsync,

    COALESCE(NULLIF(TRIM(employeetype), ''), 'UNKNOWN') AS employeetype,

    COALESCE(TRY_CAST(roleid AS NUMBER(38,0)), -1) AS roleid,

    COALESCE(TRY_CAST(isactive AS NUMBER(38,0)), 0) AS isactive,

    COALESCE(NULLIF(TRIM(employeename), ''), 'UNKNOWN') AS employeename,

    COALESCE(
        TRY_TO_DATE(createddate, 'DD-MM-YYYY HH24:MI'),
        TO_DATE('1900-01-01')
    ) AS craeteddate

FROM {{ source('tdsg_source', 'employees') }}