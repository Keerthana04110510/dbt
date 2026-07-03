{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(purchaserid, -1) AS purchaserid,

    COALESCE(isactive, FALSE) AS isactive,

    COALESCE(year, 0) AS year,

    COALESCE(quarter, 0) AS quarter,

    COALESCE(id, -1) AS id,

    COALESCE(NULLIF(TRIM(purchasername), ''), 'UNKNOWN') AS purchasername,

    COALESCE(NULLIF(TRIM(division), ''), 'UNKNOWN') AS division,

    COALESCE(NULLIF(TRIM(department), ''), 'UNKNOWN') AS department,

    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(
            NULLIF(TRIM(fromdate), 'NULL'),
            'DD-MM-YYYY HH24:MI'
        ),
        TO_TIMESTAMP_NTZ('1900-01-01 00:00:00')
    ) AS fromdate,

      TRY_TO_TIMESTAMP_NTZ(
    NULLIF(TRIM(todate), 'NULL'),
    'DD-MM-YYYY HH24:MI'
) AS todate,

    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(
            NULLIF(TRIM(startdate), 'NULL'),
            'DD-MM-YYYY HH24:MI'
        ),
        TO_TIMESTAMP_NTZ('1900-01-01 00:00:00')
    ) AS startdate,

    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(
            NULLIF(TRIM(modifieddate), 'NULL'),
            'DD-MM-YYYY HH24:MI'
        ),
        TO_TIMESTAMP_NTZ('1900-01-01 00:00:00')
    ) AS modifieddate,

    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(
            NULLIF(TRIM(createddate), 'NULL'),
            'DD-MM-YYYY HH24:MI'
        ),
        TO_TIMESTAMP_NTZ('1900-01-01 00:00:00')
    ) AS createddate

FROM {{ source('tdsg_source', 'purchaserhandlingdivision_prd') }}