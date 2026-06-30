{{
    config(
        materialized='incremental',
        unique_key='porid',
        incremental_strategy='merge'
    )
}}

SELECT
    porid,
    porno,
    departmentkey,
    divisionkey,
    purchasinggroupkey,
    employeekey,
    datekey,
    porvalue_inr,
    status,
    submitteddate,
    pono,
    podate,
    tatdays,
    tatbucket,
    isconvertedtopo,
    reviseno,
    option1,
    option2,
    isdeleted,
    ringiid,
    finalvendorid,
    ringino,
    ringistatus,
    ringivalue_inr,
    purchaserid,
    purchasername
FROM {{ ref('int_por_tat') }}
{% if is_incremental() %}
WHERE submitteddate >
(
    SELECT COALESCE(MAX(submitteddate),'1900-01-01')
    FROM {{ this }}
)
{% endif %}