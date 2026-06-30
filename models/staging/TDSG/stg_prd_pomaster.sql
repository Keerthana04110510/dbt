{{
    config(
        materialized='table'
    )
}}

select
    pornumber,
    porrequester,
    ringino,
    spenddetails,
    sappr,
    vendorcode,
    currency,
    createdby,
    trim(division) as division,
    totalpovalue,
    porvalue,
    NULLIF(TRIM(ponumber), 'NULL') AS ponumber,
    TRY_TO_NUMBER(NULLIF(exchangerate,'NULL'),18,2) AS exchangerate,
    try_to_number(nullif(additionalcharge, 'NULL'), 18, 2) as additionalcharge,
    try_to_date(nullif(podate, 'NULL'), 'dd-mm-yyyy hh24:mi') as podate,
    try_to_date(nullif(deliverydate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as deliverydate,
    trim(vendorname) as vendorname,
    try_to_number(nullif(povalue, 'NULL'), 18, 2) as povalue,
    try_to_date(nullif(pipelinerundate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as pipelinerundate

from {{ source('tdsg_source','prd_pomaster') }}
