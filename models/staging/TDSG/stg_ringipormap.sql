{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(ringipormapkey, -1) AS ringipormapkey,

    COALESCE(porid, -1) AS porid,

    COALESCE(ringiid, -1) AS ringiid,

    COALESCE(NULLIF(TRIM(finalvendorid), ''), 'UNKNOWN') AS finalvendorid,

    COALESCE(isdeleted, 0) AS isdeleted,

    COALESCE(
        TRY_TO_NUMBER(NULLIF(TRIM(amount), 'NULL'), 18, 2),
        0.00
    ) AS amount,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(createddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'ringipormap') }}