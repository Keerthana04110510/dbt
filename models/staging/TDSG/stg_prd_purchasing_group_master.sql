{{
    config(
        materialized='table'
    )
}}

select
    cast(purchasinggroupkey as int) as purchasinggroupkey,
    spid,
    groupcode,
    activeflag,
    trim(groupname) as groupname,
    try_to_timestamp(nullif(createddate, 'NULL'), 'DD-MM-YYYY HH24:MI')
        as createddate

from {{ source('tdsg_source', 'prd_purchasing_group_master') }}
