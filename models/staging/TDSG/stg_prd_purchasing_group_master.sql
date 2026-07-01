{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(purchasinggroupkey, -1) AS purchasinggroupkey,

    COALESCE(spid, -1) AS spid,

    COALESCE(NULLIF(TRIM(groupcode), ''), 'UNKNOWN') AS groupcode,

    COALESCE(NULLIF(TRIM(groupname), ''), 'UNKNOWN') AS groupname,

    COALESCE(activeflag, 0) AS activeflag,

    COALESCE(
        TRY_TO_TIMESTAMP_NTZ(
            NULLIF(TRIM(createddate), 'NULL'),
            'DD-MM-YYYY HH24:MI'
        ),
        TO_TIMESTAMP_NTZ('1900-01-01 00:00:00')
    ) AS createddate

FROM {{ source('tdsg_source', 'prd_purchasing_group_master') }}