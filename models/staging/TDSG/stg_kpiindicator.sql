{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(id, -1) AS id,

    COALESCE(kpiyear, 0) AS kpiyear,

    COALESCE(NULLIF(TRIM(kpimonth), ''), 'UNKNOWN') AS kpimonth,

    COALESCE(NULLIF(TRIM(kpi), ''), 'UNKNOWN') AS kpi,

    COALESCE(target, 0) AS target,

    COALESCE(isactive, 0) AS isactive,

    COALESCE(
        TRY_TO_DATE(NULLIF(TRIM(createdat), 'NULL'), 'DD-MM-YYYY'),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'kpiindicator') }}