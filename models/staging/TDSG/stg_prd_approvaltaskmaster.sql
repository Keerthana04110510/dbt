{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(approvertaskid, -1) AS approvertaskid,

    COALESCE(NULLIF(TRIM(formtype), ''), 'UNKNOWN') AS formtype,

    COALESCE(formid, -1) AS formid,

    COALESCE(assignedtouserid, -1) AS assignedtouserid,

    COALESCE(NULLIF(TRIM(delegateuserid), ''), 'UNKNOWN') AS delegateuserid,

    COALESCE(NULLIF(TRIM(delegateby), ''), 'UNKNOWN') AS delegateby,

    COALESCE(NULLIF(TRIM(delegateon), ''), 'UNKNOWN') AS delegateon,

    COALESCE(NULLIF(TRIM(status), ''), 'UNKNOWN') AS status,

    COALESCE(NULLIF(TRIM(role), ''), 'UNKNOWN') AS role,

    COALESCE(sequenceno, -1) AS sequenceno,

    COALESCE(NULLIF(TRIM(actiontakenby), ''), 'UNKNOWN') AS actiontakenby,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(actiontakendate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS actiontakendate,

    COALESCE(createdby, -1) AS createdby,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(src_createddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS src_createddate,

    COALESCE(NULLIF(TRIM(modifiedby), ''), 'UNKNOWN') AS modifiedby,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(modifieddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS modifieddate,

    COALESCE(isactive, 0) AS isactive,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(createddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'prd_approvaltaskmaster') }}