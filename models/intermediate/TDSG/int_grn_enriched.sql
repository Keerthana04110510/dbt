{{ config(materialized='view') }}

WITH grn AS (
    SELECT * FROM {{ ref('stg_grn_details') }}
    WHERE
        UPPER(TRIM(DocumentType)) != 'ZSTO'   
        AND UPPER(TRIM(PORNO))    != 'UNK'    
),

po AS (
    SELECT DISTINCT PONumber, VendorName
    FROM {{ ref('stg_prd_pomaster') }}
),

division_mapping AS (
    SELECT * FROM {{ ref('stg_divisionmapping') }}
),

purchasing_group AS (
    SELECT * FROM {{ ref('stg_prd_purchasing_group_master') }}
),

enriched AS (
    SELECT
        grn.PurchasingDocument,
        grn.PORNO,
        grn.DocumentType,
        grn.VendorCode,
        po.VendorName,
        grn.PurchasingOrganization,
        dm.DivisionKey,
        grn.PurchasingGroup,
        pg.PurchasingGroupKey,
        grn.DeliveryDate,
        grn.GRNDate,
        grn.OrderQuantity,
        grn.GRNQuantity,
        grn.TotalDeliveredQuantity,
        grn.PendingToDelivered,
        CASE
            WHEN grn.GRNDate IS NULL OR grn.DeliveryDate IS NULL THEN 'N'
            WHEN grn.GRNDate <= grn.DeliveryDate                  THEN 'Y'
            ELSE 'N'
        END AS IsOnTime,
        CASE
            WHEN grn.GRNDate > grn.DeliveryDate
            THEN DATEDIFF(day, grn.DeliveryDate, grn.GRNDate)
            ELSE 0
        END AS DaysLate
    FROM grn
    LEFT JOIN po
        ON grn.PurchasingDocument = po.PONumber
    LEFT JOIN division_mapping dm
        ON TRIM(grn.PurchasingOrganization) = TRIM(dm.PurchaseOrganization)
    LEFT JOIN purchasing_group pg
        ON TRIM(grn.PurchasingGroup) = TRIM(pg.GroupCode)
)
SELECT * FROM enriched