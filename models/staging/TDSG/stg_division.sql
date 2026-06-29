{{
    config(
        materialized='table'
    )
}}

select
    cast(divisionkey as int) as divisionkey,
    spid,
    divisionshortcode,
    divisionhead,
    deputydivisionhead,
    activeflag,
    coalesce(trim(divisionname), 'unknown') as divisionname,
    try_to_date(createddate, 'dd-mm-yyyy hh24:mi') as createddate

from {{ source('tdsg_source','division') }}
