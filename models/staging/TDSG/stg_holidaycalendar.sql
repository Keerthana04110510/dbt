{{
    config(
        materialized='table'
    )
}}

select
    cast(id as int) as id,
    try_to_date(holidaydate, 'dd-mm-yyyy hh24:mi') as holidaydate

from {{ source('tdsg_source','holidaycalendar') }} 
