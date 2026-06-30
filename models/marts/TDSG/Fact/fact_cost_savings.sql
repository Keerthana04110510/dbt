{{ config(
    materialized = 'incremental',
    unique_key   = 'PONumber'
) }}

WITH po AS (
    SELECT * FROM {{ ref('int_po_with_division') }}
),

pg AS (
    SELECT PurchasingGroupKey
    FROM {{ ref('stg_prd_purchasing_group_master') }}
),

final AS (
    SELECT
        po.PONumber,
        po.PORNumber,
        {{ date_to_key('po.PODate') }}        AS DateKey,
        po.DivisionKey,
        po.PurchaserID,
        po.PurchaserName,
        po.VendorCode,
        po.VendorName,
        po.RingiNO                            AS RingiNumber,
        po.PORValue                           AS PORValue_INR,
        po.AdditionalCharge,
        po.POValue                            AS POValue_INR,
        po.PORValue - po.POValue      AS CostSavings_INR,
        CASE
            WHEN po.PORValue = 0 THEN 0
            ELSE ROUND((po.PORValue - po.POValue) / NULLIF(po.PORValue,0) * 100, 2)
        END                                    AS SavingsPercent,
        po.PODate,
        po.DeliveryDate,
        po.SpendDetails,
        {{ audit_columns('SAP_ERP') }}
    FROM po
)

SELECT * FROM final

{% if is_incremental() %}
WHERE PODate > (SELECT COALESCE(MAX(PODate), '1900-01-01'::DATE) FROM {{ this }})
{% endif %}