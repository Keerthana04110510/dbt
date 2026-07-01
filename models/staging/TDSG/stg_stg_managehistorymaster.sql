{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(id, -1) AS id,

    COALESCE(historyid, -1) AS historyid,

    COALESCE(formid, -1) AS formid,

    COALESCE(actiontakenbyuserid, -1) AS actiontakenbyuserid,

    CASE
        WHEN role IS NULL
             OR TRIM(role) = ''
             OR UPPER(TRIM(role)) = 'NULL'
        THEN 'UNKNOWN'
        ELSE TRIM(role)
    END AS role,

    CASE
        WHEN actiontype IS NULL
             OR TRIM(actiontype) = ''
             OR UPPER(TRIM(actiontype)) = 'NULL'
        THEN 'UNKNOWN'
        ELSE TRIM(actiontype)
    END AS actiontype,

    COALESCE(delegateuserid, -1) AS delegateuserid,

    COALESCE(isactive, 0) AS isactive,

    CASE
        WHEN formtype IS NULL
             OR TRIM(formtype) = ''
             OR UPPER(TRIM(formtype)) = 'NULL'
        THEN 'UNKNOWN'
        ELSE TRIM(formtype)
    END AS formtype,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(actiontakendatetime), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS actiontakendatetime,

    CASE
        WHEN status IS NULL
             OR TRIM(status) = ''
             OR UPPER(TRIM(status)) = 'NULL'
        THEN 'UNKNOWN'
        ELSE TRIM(status)
    END AS status,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(createdat), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS createdate

FROM {{ source('tdsg_source', 'stg_managehistorymaster') }}