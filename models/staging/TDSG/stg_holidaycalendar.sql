{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(id, -1) AS id,

    COALESCE(
        CAST(
            COALESCE(
                TRY_TO_TIMESTAMP(
                    NULLIF(TRIM(holidaydate), 'NULL'),
                    'DD-MM-YYYY HH24:MI'
                ),
                TRY_TO_TIMESTAMP(
                    NULLIF(TRIM(holidaydate), 'NULL'),
                    'DD-MM-YYYY'
                )
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS holidaydate

FROM {{ source('tdsg_source', 'holidaycalendar') }}