{{
    config(
        materialized='table'
    )
}}

select
    cast(ringikey as int) as ringikey,
    cast(departmentkey as int) as departmentkey,
    cast(ringiapprovalitemid as int) as ringiapprovalitemid,
    ringino,
    tempringino,
    plantkey,
    categorytype,
    cast(amount as number(18, 2)) as amount,
    cast(basecurrency as varchar) as basecurrency,
    cast(totalamount_inr as number(18, 2)) as totalamount_inr,
    conversionrate,
    ringilevel,
    poroption,
    issubmitted,
    modifiedby,
    createdby,
    issubringi,
    trim(status) as status,
    try_to_date(submitteddate, 'dd-mm-yyyy hh24:mi') as submitteddate,
    try_to_date(src_createddate, 'dd-mm-yyyy hh24:mi') as src_createddate,
    try_to_date(modifieddate, 'dd-mm-yyyy hh24:mi') as modifieddate,
    try_to_date(createddate, 'dd-mm-yyyy hh24:mi') as createddate

from {{ source('tdsg_source','stg_ringimaster') }}
