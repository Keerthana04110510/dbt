{{
    config(
        materialized='table'
    )
}}

select
    cast(id as int) as id,
    kpiyear,
    kpimonth,
    kpi,
    target,
    isactive,
    try_to_date(nullif(createdat, 'NULL'), 'dd-mm-yyyy hh24:mi') as createddate

from {{ source('tdsg_source', 'kpiindicator') }}
