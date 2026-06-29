{{
    config(
        materialized='table'
    )
}}

select
    cast(approvertaskid as int) as approvertaskid,
    cast(formtype as varchar) as formtype,
    cast(formid as int) as formid,
    assignedtouserid,
    delegateuserid,
    delegateby,
    delegateon,
    role,
    sequenceno,
    actiontakenby,
    createdby,
    modifiedby,
    isactive,
    trim(status) as status,
    try_to_date(actiontakendate, 'dd-mm-yyyy hh24:mi') as actiontakendate,
    try_to_date(src_createddate, 'dd-mm-yyyy hh24:mi') as src_createddate,
    try_to_date(modifieddate, 'dd-mm-yyyy hh24:mi') as modifieddate,
    try_to_date(createddate, 'dd-mm-yyyy hh24:mi') as createddate

from {{ source('tdsg_source', 'prd_approvaltaskmaster') }}
