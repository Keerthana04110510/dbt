{{ config(materialized='view') }}

WITH base AS (

    SELECT *
    FROM {{ ref('int_delivery_base') }}

),

purchaser AS (

    SELECT DISTINCT

        PurchaserID,

        Division,

        Department,

        FromDate,

        ToDate

    FROM {{ ref('dim_purchaser1') }}

),

final AS (

SELECT

    base.PONumber,

    base.POItem,

    base.PORNumber,

    base.PODate,

    base.DeliveryDate,

    base.GRNDate,

    base.VendorCode,

    base.DepartmentKey,

    base.DivisionKey,

    base.DepartmentName,

    base.DivisionName,

    COALESCE(pur.PurchaserID,-1) AS PurchaserID,

    base.OrderQuantity,

    base.GRNQuantity,

    base.TotalDeliveredQuantity

FROM base

LEFT JOIN purchaser pur

ON UPPER(TRIM(base.DivisionName))
=
UPPER(TRIM(pur.Division))

AND UPPER(TRIM(base.DepartmentName))
=
UPPER(TRIM(pur.Department))

AND base.GRNDate BETWEEN pur.FromDate
                     AND COALESCE(pur.ToDate,DATE '9999-12-31')

)

SELECT *

FROM final