{{
    config(
        materialized='table'
    )
}}

SELECT
    COALESCE(purchasingdocument, -1) AS purchasingdocument,

    COALESCE(item, -1) AS item,

    COALESCE(NULLIF(TRIM(ringino), ''), 'UNKNOWN') AS ringino,

    COALESCE(NULLIF(TRIM(porno), ''), 'UNKNOWN') AS porno,

    COALESCE(NULLIF(TRIM(companycode), ''), 'UNKNOWN') AS companycode,

    COALESCE(NULLIF(TRIM(documenttype), ''), 'UNKNOWN') AS documenttype,

    COALESCE(NULLIF(TRIM(vendorcode), ''), 'UNKNOWN') AS vendorcode,

    COALESCE(NULLIF(TRIM(purchasingorganization), ''), 'UNKNOWN')
        AS purchasingorganization,

    COALESCE(NULLIF(TRIM(purchasinggroup), ''), 'UNKNOWN')
        AS purchasinggroup,

    COALESCE(NULLIF(TRIM(paymentterm), ''), 'UNKNOWN') AS paymentterm,

    COALESCE(NULLIF(TRIM(currency), ''), 'UNKNOWN') AS currency,

    COALESCE(conversion, 0) AS conversion,

    COALESCE(NULLIF(TRIM(podocument), ''), 'UNKNOWN') AS podocument,

    COALESCE(NULLIF(TRIM(materialcode), ''), 'UNKNOWN') AS materialcode,

    COALESCE(orderquantity, 0) AS orderquantity,

    COALESCE(unitprice, 0.00) AS unitprice,

    COALESCE(NULLIF(TRIM(glaccount), ''), 'UNKNOWN') AS glaccount,

    COALESCE(NULLIF(TRIM(costcenter), ''), 'UNKNOWN') AS costcenter,

    COALESCE(NULLIF(TRIM(materialgroup), ''), 'UNKNOWN') AS materialgroup,

    COALESCE(NULLIF(TRIM(plant), ''), 'UNKNOWN') AS plant,

    COALESCE(NULLIF(TRIM(tazcode), ''), 'UNKNOWN') AS tazcode,

    COALESCE(NULLIF(TRIM(hsn), ''), 'UNKNOWN') AS hsn,

    COALESCE(NULLIF(TRIM(deliverycompletionindicators), ''), 'UNKNOWN')
        AS deliverycompletionindicators,

    COALESCE(NULLIF(TRIM(deletionindicator), ''), 'UNKNOWN')
        AS deletionindicator,

    COALESCE(grnquantity, 0.00) AS grnquantity,

    COALESCE(totaldeliveredquantity, 0.00) AS totaldeliveredquantity,

    COALESCE(pendingtodelivered, 0.0) AS pendingtodelivered,

    COALESCE(freightcharges, 0.00) AS freightcharges,

    COALESCE(poramount, 0.00) AS poramount,

    COALESCE(
        TRY_TO_DATE(NULLIF(TRIM(deliverydate), 'NULL'), 'DD-MM-YYYY'),
        TO_DATE('1900-01-01')
    ) AS deliverydate,

    COALESCE(
        TRY_TO_DATE(NULLIF(TRIM(grndate), 'NULL'), 'DD-MM-YYYY'),
        TO_DATE('1900-01-01')
    ) AS grndate,

    COALESCE(
        TRY_TO_DATE(NULLIF(TRIM(createddate), 'NULL'), 'DD-MM-YYYY'),
        TO_DATE('1900-01-01')
    ) AS createddate

FROM {{ source('tdsg_source', 'grn_details') }}
