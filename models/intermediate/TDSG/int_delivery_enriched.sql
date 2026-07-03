{{ config(materialized='view') }}

WITH base AS (

SELECT *

FROM {{ ref('int_delivery_base') }}

),

WITH purchaser AS (

SELECT *

FROM (

SELECT

*,

ROW_NUMBER() OVER(

PARTITION BY
Division,
Department,
FromDate,
ToDate

ORDER BY
ModifiedDate DESC,
CreatedDate DESC

) rn

FROM {{ ref('dim_purchaser1') }}

)

WHERE rn = 1

)

SELECT

base.*,

pur.PurchaserID

FROM base

LEFT JOIN purchaser pur

ON UPPER(TRIM(base.DivisionName))
=
UPPER(TRIM(pur.Division))

AND UPPER(TRIM(base.DepartmentName))
=
UPPER(TRIM(pur.Department))

AND base.GRNDate
BETWEEN
pur.FromDate
AND
COALESCE(pur.ToDate,DATE '9999-12-31')