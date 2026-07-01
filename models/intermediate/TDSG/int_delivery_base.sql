{{ config(materialized='view') }}

WITH
/*=========================================================
GRN CLEAN
=========================================================*/

grn_clean AS (

    SELECT

        TRIM(CAST(PurchasingDocument AS VARCHAR))      AS PONumber,

        TRIM(CAST(Item AS VARCHAR))                    AS POItem,

        TRIM(PORNo)                                   AS PORNumber,

        TRY_TO_DATE(PODocument)                       AS PODate,

        DeliveryDate,

        GRNDate,

        UPPER(TRIM(Currency))                         AS Currency,

        CAST(OrderQuantity AS DECIMAL(18,3))          AS OrderQuantity,

        CAST(GRNQuantity AS DECIMAL(18,3))            AS GRNQuantity,

        CAST(TotalDeliveredQuantity AS DECIMAL(18,3)) AS TotalDeliveredQuantity

    FROM {{ ref('stg_grn_details') }}

    WHERE GRNDate <> DATE '1900-01-01'

),

/*=========================================================
Aggregate duplicate GRNs
=========================================================*/

grn_base AS (

    SELECT

        PONumber,

        POItem,

        GRNDate,

        MAX(PORNumber)                 AS PORNumber,

        MAX(PODate)                    AS PODate,

        MAX(DeliveryDate)              AS DeliveryDate,

        MAX(OrderQuantity)             AS OrderQuantity,

        SUM(GRNQuantity)               AS GRNQuantity,

        SUM(TotalDeliveredQuantity)    AS TotalDeliveredQuantity

    FROM grn_clean

    GROUP BY

        PONumber,

        POItem,

        GRNDate

),

/*=========================================================
Latest PO Header
=========================================================*/

po_rank AS (

    SELECT

        TRIM(PONumber)                     AS PONumber,

        TRIM(VendorName)                   AS VendorName,

        Currency,

        PipelineRunDate,

        ROW_NUMBER() OVER(

            PARTITION BY TRIM(PONumber)

            ORDER BY PipelineRunDate DESC NULLS LAST

        ) rn

    FROM {{ ref('stg_prd_pomaster') }}

),

latest_po AS (

    SELECT

        PONumber,

        VendorName,

        Currency

    FROM po_rank

    WHERE rn=1

),

/*=========================================================
Remove Duplicate POR
=========================================================*/

por_rank AS (

    SELECT

        *,

        ROW_NUMBER() OVER(

            PARTITION BY TRIM(PorNo)

            ORDER BY PORID

        ) rn

    FROM {{ ref('stg_stg_pormaster') }}

    WHERE IsDeleted=0

),

por_clean AS (

    SELECT *

    FROM por_rank

    WHERE rn=1

),

/*=========================================================
Department + Division
=========================================================*/

por_department AS (

    SELECT

        TRIM(p.PorNo) AS PORNumber,

        d.DepartmentName,

        dv.DivisionName

    FROM por_clean p

    LEFT JOIN {{ ref('dim_department1') }} d

        ON p.DepartmentId=d.DepartmentKey

    LEFT JOIN {{ ref('dim_division') }} dv

        ON d.DivisionKey=dv.DivisionKey

),

/*=========================================================
Final Base
=========================================================*/

final AS (

SELECT

    g.PONumber,

    g.POItem,

    g.PORNumber,

    g.PODate,

    g.DeliveryDate,

    g.GRNDate,

    p.VendorName,

    d.DivisionName,

    d.DepartmentName,

    g.OrderQuantity,

    g.GRNQuantity,

    g.TotalDeliveredQuantity,

    p.Currency

FROM grn_base g

LEFT JOIN latest_po p

    ON g.PONumber=p.PONumber

LEFT JOIN por_department d

    ON g.PORNumber=d.PORNumber

)

SELECT *

FROM final