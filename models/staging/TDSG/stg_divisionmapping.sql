{{
    config(
        materialized='table'
    )
}}

select
    spid,
    cast(divisionkey as int) as divisionkey,
    purchaseorganization,
    description,
    activeflag,
    coalesce(division, 'unknown') as division,
    try_to_date(createddate, 'dd-mm-yyyy hh24:mi') as createddate

from {{ source('tdsg_source', 'divisionmapping') }}
