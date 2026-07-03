{{ config(

    materialized='incremental',

    unique_key=['PONumber','POItem','GRNDate'],

    incremental_strategy='merge'

) }}

WITH base AS (

SELECT *

FROM {{ ref('int_delivery_enriched') }}

),

final AS (

SELECT

{{ dbt_utils.generate_surrogate_key([

'PONumber',

'POItem',

'PORNumber',

'GRNDate'

]) }} AS ID,

PONumber,

POItem,

PORNumber,

PODate,

DeliveryDate,

GRNDate,

COALESCE(VendorCode,'UNK') AS VendorCode,

COALESCE(DepartmentKey,-1) AS DepartmentKey,

COALESCE(DivisionKey,-1) AS DivisionKey,

COALESCE(PurchaserID,-1) AS PurchaserID,

OrderQuantity,

GRNQuantity,

TotalDeliveredQuantity,

CASE

WHEN OrderQuantity<=0 THEN NULL

WHEN TotalDeliveredQuantity>OrderQuantity THEN 0

ELSE OrderQuantity-TotalDeliveredQuantity

END AS PendingGRNQuantity,

CASE

WHEN OrderQuantity<=0 THEN 'Order Qty Missing'

WHEN TotalDeliveredQuantity>OrderQuantity THEN 'Over Delivered'

WHEN TotalDeliveredQuantity=OrderQuantity THEN 'Completed'

WHEN TotalDeliveredQuantity>0 THEN 'Partial'

ELSE 'Pending'

END AS DeliveryStatus,

CASE

WHEN GRNDate IS NULL
OR DeliveryDate IS NULL THEN NULL

WHEN GRNDate<=DeliveryDate THEN 'Y'

ELSE 'N'

END AS IsOnTimeGRN,

CASE

WHEN GRNDate IS NULL
OR DeliveryDate IS NULL THEN NULL

WHEN GRNDate>DeliveryDate

THEN DATEDIFF(DAY,DeliveryDate,GRNDate)

ELSE 0

END AS DeliveryDelayDays,

{{ audit_columns('SAP_ERP') }}

FROM base

)

SELECT *

FROM final

{% if is_incremental() %}

WHERE NOT EXISTS (

SELECT 1

FROM {{ this }} t

WHERE t.PONumber=final.PONumber

AND t.POItem=final.POItem

AND t.GRNDate=final.GRNDate

)

{% endif %}