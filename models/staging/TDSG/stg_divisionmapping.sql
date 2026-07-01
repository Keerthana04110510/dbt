{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(TRY_CAST(spid AS NUMBER(38,0)), -1) AS spid,

    COALESCE(TRY_CAST(divisionkey AS NUMBER(38,0)), -1) AS divisionkey,

    COALESCE(NULLIF(TRIM(purchaseorganization), ''), 'UNKNOWN') AS purchaseorganization,

    COALESCE(NULLIF(TRIM(description), ''), 'UNKNOWN') AS description,

    COALESCE(TRY_CAST(activeflag AS NUMBER(38,0)), 0) AS activeflag,

    COALESCE(NULLIF(TRIM(division), ''), 'UNKNOWN') AS division,

    COALESCE(
        TRY_TO_DATE(createddate, 'DD-MM-YYYY HH24:MI'),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'divisionmapping') }}