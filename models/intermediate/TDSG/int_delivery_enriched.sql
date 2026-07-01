{{ config(materialized='view') }}

WITH base AS (

    SELECT *
    FROM {{ ref('int_delivery_base') }}

),

/*=========================================================
Remove duplicate Purchaser Mapping
=========================================================*/

purchaser_rank AS (

    SELECT

        Division,

        Department,

        FromDate,

        ToDate,

        PurchaserID,

        PurchaserName,

        IsActive,

        ModifiedDate,

        CreatedDate,

        ROW_NUMBER() OVER (

            PARTITION BY
                TRIM(Division),
                TRIM(Department),
                FromDate,
                ToDate

            ORDER BY

                CASE
                    WHEN IsActive='Y' THEN 1
                    ELSE 2
                END,

                ModifiedDate DESC NULLS LAST,

                CreatedDate DESC NULLS LAST

        ) AS rn

    FROM {{ ref('stg_purchaserhandlingdivision_prd') }}

    WHERE
        Division IS NOT NULL
        AND Department IS NOT NULL
        AND FromDate IS NOT NULL
        AND ToDate IS NOT NULL
        AND PurchaserID IS NOT NULL

),

/*=========================================================
Keep only best mapping
=========================================================*/

purchaser AS (

    SELECT

        Division,

        Department,

        FromDate,

        ToDate,

        PurchaserID,

        PurchaserName

    FROM purchaser_rank

    WHERE rn=1

),

/*=========================================================
Join Purchaser
=========================================================*/

final AS (

SELECT

    base.*,

    p.PurchaserID AS PurchaserEmployeeID,

    p.PurchaserName

FROM base

LEFT JOIN purchaser p

ON TRIM(base.DivisionName)=TRIM(p.Division)

AND TRIM(base.DepartmentName)=TRIM(p.Department)

AND base.PODate BETWEEN p.FromDate AND p.ToDate

)

SELECT *

FROM final