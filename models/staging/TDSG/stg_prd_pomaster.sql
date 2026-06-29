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
    ponumber,
    vendorcode,
    currency,
    exchangerate,
    cast(porvalue as number(18, 2)) as porvalue,
    cast(totalpovalue as number(18, 2)) as totalpovalue,
    createdby,
    trim(division) as division,
    try_to_number(nullif(additionalcharge, 'NULL'), 18, 2) as additionalcharge,
    try_to_date(nullif(podate, 'NULL'), 'dd-mm-yyyy hh24:mi') as podate,
    try_to_date(nullif(deliverydate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as deliverydate,
    trim(vendorname) as vendorname,
    try_to_number(nullif(povalue, 'NULL'), 18, 2) as povalue,
    try_to_date(nullif(pipelinerundate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as pipelinerundate

from {{ source('tdsg_source','prd_pomaster') }}
