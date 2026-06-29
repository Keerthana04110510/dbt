{{
    config(
        materialized='table'
    )
}}

select
    cast(purchaserid as int) as purchaserid,
    isactive,
    year,
    quarter,
    cast(id as int) as id,
    trim(purchasername) as purchasername,
    trim(division) as division,
    trim(department) as department,
    try_to_timestamp(nullif(fromdate, 'NULL'), 'DD-MM-YYYY HH24:MI')
        as fromdate,
    try_to_timestamp(nullif(todate, 'NULL'), 'DD-MM-YYYY HH24:MI') as todate,
    try_to_timestamp(nullif(startdate, 'NULL'), 'DD-MM-YYYY HH24:MI')
        as startdate,
    try_to_timestamp(nullif(modifieddate, 'NULL'), 'DD-MM-YYYY HH24:MI')
        as modifieddate,
    try_to_timestamp(nullif(createddate, 'NULL'), 'DD-MM-YYYY HH24:MI')
        as createddate

from {{ source('tdsg_source', 'purchaserhandlingdivision_prd') }}
