{{
    config(
        materialized='table'
    )
}}

select
    cast(id as int) as id,
    cast(historyid as int) as historyid,
    cast(formid as int) as formid,
    actiontakenbyuserid,
    role,
    actiontype,
    delegateuserid,
    isactive,
    trim(formtype) as formtype,
    try_to_date(actiontakendatetime, 'dd-mm-yyyy hh24:mi')
        as actiontakendatetime,
    trim(status) as status,
    try_to_date(createdat, 'dd-mm-yyyy hh24:mi') as createdate

from {{ source('tdsg_source','stg_managehistorymaster') }}
