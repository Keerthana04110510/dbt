{{ config(
    materialized = 'incremental',
    unique_key   = ['PurchasingDocument', 'Item']
) }}

WITH grn AS (
    SELECT * FROM {{ ref('int_grn_enriched') }}
),

final AS (
    SELECT
        grn.PurchasingDocument,
        grn.PORNO              AS PORNumber,
        grn.DocumentType,
        grn.VendorCode,
        grn.VendorName,
        grn.DivisionKey,
        grn.PurchasingGroupKey,
        {{ date_to_key('grn.GRNDate') }}      AS GRNDateKey,
        {{ date_to_key('grn.DeliveryDate') }} AS DeliveryDateKey,
        grn.GRNDate,
        grn.DeliveryDate,
        grn.OrderQuantity,
        grn.GRNQuantity,
        grn.TotalDeliveredQuantity,
        grn.PendingToDelivered AS PendingQuantity,
        grn.IsOnTime,
        grn.DaysLate,
        {{ audit_columns('SAP_GRN') }}
    FROM grn
)

SELECT * FROM final

{% if is_incremental() %}
WHERE GRNDate > (SELECT COALESCE(MAX(GRNDate), '1900-01-01'::DATE) FROM {{ this }})
{% endif %}