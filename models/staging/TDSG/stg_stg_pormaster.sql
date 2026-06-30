{{
    config(
        materialized='table'
    )
}}

select
    cast(porid as int) as porid,
    preferredvendorid,
    plantid,
    cast(purchasinggroupid as int) as purchasinggroupid,
    cast(purchasingorgid as int) as purchasingorgid,
    porno,
    cast(totalamount as number(18, 2)) as totalamount,
    cast(basecurrency as varchar) as basecurrency,
    cast(totalamount_inr as number(18, 2)) as totalamount_inr,
    cast(conversionrate as number(18, 2)) as conversionrate,
    cast(departmentid as int) as departmentid,
    issubmitted,
    option1,
    option2,
    ringi_createdby,
    ringi_modifiedby,
    isdeleted,
    reviseno,
    sap_po,
    sap_pr,
    issynced,
    sapissueorder,
    try_to_number(nullif(pono,'NULL')) as pono,
    try_to_number(nullif(ringicreatedby,'NULL')) AS ringicreatedby,
    try_to_date(requireddate, 'dd-mm-yyyy hh24:mi') as requireddate,
    trim(status) as status,
    try_to_date(ringi_resubmitteddate, 'dd-mm-yyyy hh24:mi')
        as ringi_resubmitteddate,
    try_to_date(ringi_submitteddate, 'dd-mm-yyyy hh24:mi')
        as ringi_submitteddate,
    try_to_date(ringi_createddate, 'dd-mm-yyyy hh24:mi') as ringi_createddate,
    try_to_date(ringi_modifieddate, 'dd-mm-yyyy hh24:mi') as ringi_modifieddate,
    try_to_date(podate, 'dd-mm-yyyy hh24:mi') as podate,
    try_to_date(createddate, 'dd-mm-yyyy hh24:mi') as createddate

from {{ source('tdsg_source','stg_pormaster') }}
