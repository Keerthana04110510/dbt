{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(TRY_CAST(divisionkey AS NUMBER(38,0)), -1) AS divisionkey,

    COALESCE(TRY_CAST(spid AS NUMBER(38,0)), -1) AS spid,

    COALESCE(NULLIF(TRIM(divisionshortcode), ''), 'UNKNOWN') AS divisionshortcode,

    COALESCE(TRY_CAST(divisionhead AS NUMBER(38,0)), -1) AS divisionhead,

    COALESCE(TRY_CAST(deputydivisionhead AS NUMBER(38,0)), -1) AS deputydivisionhead,

    COALESCE(TRY_CAST(activeflag AS NUMBER(38,0)), 0) AS activeflag,

    COALESCE(NULLIF(TRIM(divisionname), ''), 'UNKNOWN') AS divisionname,

    COALESCE(
        TRY_TO_DATE(createddate, 'DD-MM-YYYY HH24:MI'),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'division') }}