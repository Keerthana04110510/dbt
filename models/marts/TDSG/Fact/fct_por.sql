{{
    config(
        materialized='incremental',
        unique_key='PORID',
        incremental_strategy='merge'
    )
}}

SELECT
    PORID AS ID,

    -- Dimension Keys
    {{ date_to_key('PORDate') }} AS DateKey,
    DivisionKey,
    PurchasingGroupId AS PurchasingGroupKey,
    PurchaserID,

    -- Business Columns
    DivisionName,
    DepartmentName,
    PORStatus,
    RingiNo AS RingiNumber,
    PurchasingGroup,

    PORDate,
    PorNo AS PORNumber,
    PORValue,
    BaseCurrency AS PORCurrency,

    RequestorName,

    PODate,
    PONo AS PONumber,

    PurchaserName,

    TATDays,

    CreatedDate,

    POValue AS POValue_INR,

    RingiStatus,

    FinalVendorId,
    VendorCode,
    VendorName,
    
    -- Audit Columns
    {{ audit_columns('SAP_ERP') }}

FROM {{ ref('int_por_enricheds') }} src

{% if is_incremental() %}

WHERE NOT EXISTS (

    SELECT 1
    FROM {{ this }} t
    WHERE t.ID = src.PORID

)

{% endif %}