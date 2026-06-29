{{
    config(
        materialized='table'
    )
}}

select
    cast(ringipormapkey as int) as ringipormapkey,
    cast(porid as int) as porid,
    cast(ringiid as int) as ringiid,
    finalvendorid,
    isdeleted,
    try_to_number(nullif(amount, 'NULL'), 18, 2) as amount,
    try_to_date(nullif(createddate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as createddate

from {{ source('tdsg_source','ringipormap') }}
