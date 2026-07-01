{{
    config(
        materialized='table'
    )
}}

select

    coalesce(
        nullif(trim(pornumber), 'NULL'),
        'UNK'
    ) as pornumber,

    coalesce(
        nullif(trim(porrequester), 'NULL'),
        'UNK'
    ) as porrequester,

    coalesce(
        nullif(trim(ringino), 'NULL'),
        'UNK'
    ) as ringino,

    coalesce(
        nullif(trim(spenddetails), 'NULL'),
        'UNK'
    ) as spenddetails,

    coalesce(
        try_to_number(nullif(trim(to_varchar(sappr)), 'NULL')),
        -1
    ) as sappr,

    coalesce(
        nullif(trim(vendorcode), 'NULL'),
        'UNK'
    ) as vendorcode,

    coalesce(
        nullif(trim(currency), 'NULL'),
        'UNK'
    ) as currency,

    coalesce(
        nullif(trim(createdby), 'NULL'),
        'UNK'
    ) as createdby,

    coalesce(
        nullif(trim(division), 'NULL'),
        'UNK'
    ) as division,

    coalesce(
        try_to_number(nullif(trim(to_varchar(totalpovalue)), 'NULL'), 18, 2),
        0
    ) as totalpovalue,

    coalesce(
        try_to_number(nullif(trim(to_varchar(porvalue)), 'NULL'), 18, 2),
        0
    ) as porvalue,

    coalesce(
        nullif(trim(ponumber), 'NULL'),
        'UNK'
    ) as ponumber,

    coalesce(
        try_to_number(nullif(trim(to_varchar(exchangerate)), 'NULL'), 18, 2),
        0
    ) as exchangerate,

    coalesce(
        try_to_number(nullif(trim(to_varchar(additionalcharge)), 'NULL'), 18, 2),
        0
    ) as additionalcharge,

    coalesce(
        try_to_date(nullif(trim(podate), 'NULL'), 'DD-MM-YYYY'),
        to_date('1900-01-01')
    ) as podate,

    coalesce(
        try_to_date(nullif(trim(deliverydate), 'NULL'), 'DD-MM-YYYY'),
        to_date('1900-01-01')
    ) as deliverydate,

    coalesce(
        nullif(trim(vendorname), 'NULL'),
        'UNK'
    ) as vendorname,

    coalesce(
        try_to_number(nullif(trim(to_varchar(povalue)), 'NULL'), 18, 2),
        0
    ) as povalue,

    coalesce(
        try_to_date(nullif(trim(pipelinerundate), 'NULL'), 'DD-MM-YYYY'),
        to_date('1900-01-01')
    ) as pipelinerundate,

    current_timestamp() as lastupdated_date

from {{ source('tdsg_source', 'prd_pomaster') }}