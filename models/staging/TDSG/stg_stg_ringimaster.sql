{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(ringikey, -1) AS ringikey,

    COALESCE(departmentkey, -1) AS departmentkey,

    COALESCE(ringiapprovalitemid, -1) AS ringiapprovalitemid,

    COALESCE(NULLIF(TRIM(ringino), ''), 'UNKNOWN') AS ringino,

    COALESCE(NULLIF(TRIM(tempringino), ''), 'UNKNOWN') AS tempringino,

    COALESCE(plantkey, -1) AS plantkey,

    COALESCE(categorytype, -1) AS categorytype,

    COALESCE(
        TRY_TO_NUMBER(NULLIF(TRIM(amount), 'NULL'), 18, 2),
        0.00
    ) AS amount,

    COALESCE(NULLIF(TRIM(basecurrency), ''), 'UNKNOWN') AS basecurrency,

    COALESCE(
        TRY_TO_NUMBER(NULLIF(TRIM(totalamount_inr), 'NULL'), 18, 2),
        0.00
    ) AS totalamount_inr,

    COALESCE(conversionrate, 0.00) AS conversionrate,

    COALESCE(ringilevel, -1) AS ringilevel,

    COALESCE(poroption, -1) AS poroption,

    COALESCE(issubmitted, 0) AS issubmitted,

    COALESCE(NULLIF(TRIM(modifiedby), ''), 'UNKNOWN') AS modifiedby,

    COALESCE(createdby, -1) AS createdby,

    COALESCE(issubringi, 0) AS issubringi,

    COALESCE(NULLIF(TRIM(status), ''), 'UNKNOWN') AS status,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(submitteddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS submitteddate,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(src_createddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS src_createddate,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(modifieddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS modifieddate,

    COALESCE(
        CAST(
            TRY_TO_TIMESTAMP(
                NULLIF(TRIM(createddate), 'NULL'),
                'DD-MM-YYYY HH24:MI'
            ) AS DATE
        ),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'stg_ringimaster') }}