{{
    config(
        materialized='table'
    )
}}

with source as (

    select *
    from {{ source('tdsg_source', 'stg_pormaster') }}

),

renamed as (

    select

        coalesce(try_to_number(nullif(trim(to_varchar(porid)), 'NULL')), -1) as porid,

        coalesce(try_to_number(nullif(trim(to_varchar(preferredvendorid)), 'NULL')), -1) as preferredvendorid,

        coalesce(try_to_number(nullif(trim(to_varchar(plantid)), 'NULL')), -1) as plantid,

        coalesce(try_to_number(nullif(trim(to_varchar(purchasinggroupid)), 'NULL')), -1) as purchasinggroupid,

        coalesce(try_to_number(nullif(trim(to_varchar(purchasingorgid)), 'NULL')), -1) as purchasingorgid,

        coalesce(
            nullif(upper(trim(porno)), 'NULL'),
            'UNK'
        ) as porno,

        coalesce(try_to_number(nullif(trim(to_varchar(totalamount)), 'NULL')), 0) as totalamount,

        coalesce(
            nullif(upper(trim(basecurrency)), 'NULL'),
            'UNK'
        ) as basecurrency,

        coalesce(try_to_number(nullif(trim(to_varchar(totalamount_inr)), 'NULL')), 0) as totalamount_inr,

        coalesce(try_to_number(nullif(trim(to_varchar(conversionrate)), 'NULL')), 0) as conversionrate,

        coalesce(try_to_number(nullif(trim(to_varchar(departmentid)), 'NULL')), -1) as departmentid,

        case
            when upper(trim(issubmitted)) = 'Y' then 1
            when upper(trim(issubmitted)) = 'N' then 0
            else 0
        end as issubmitted,

        coalesce(
            nullif(upper(trim(option1)), 'NULL'),
            'UNK'
        ) as option1,

        coalesce(
            nullif(upper(trim(option2)), 'NULL'),
            'UNK'
        ) as option2,

        coalesce(try_to_number(nullif(trim(to_varchar(ringi_createdby)), 'NULL')), -1) as ringi_createdby,

        coalesce(
            try_to_timestamp(ringi_createddate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(ringi_createddate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as ringi_createddate,

        coalesce(try_to_number(nullif(trim(to_varchar(ringi_modifiedby)), 'NULL')), -1) as ringi_modifiedby,

        coalesce(
            try_to_timestamp(ringi_modifieddate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(ringi_modifieddate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as ringi_modifieddate,

        case
            when upper(trim(isdeleted)) = 'Y' then 1
            when upper(trim(isdeleted)) = 'N' then 0
            else 0
        end as isdeleted,

        coalesce(try_to_number(nullif(trim(to_varchar(reviseno)), 'NULL')), 0) as reviseno,

        coalesce(
            nullif(trim(cast(sap_po as string)), 'NULL'),
            'UNK'
        ) as sap_po,

        coalesce(
            nullif(trim(cast(sap_pr as string)), 'NULL'),
            'UNK'
        ) as sap_pr,

        case
            when upper(trim(issynced)) = 'Y' then 1
            when upper(trim(issynced)) = 'N' then 0
            else 0
        end as issynced,

        coalesce(
            nullif(trim(cast(sapissueorder as string)), 'NULL'),
            'UNK'
        ) as sapissueorder,

        coalesce(
            nullif(trim(cast(pono as string)), 'NULL'),
            'UNK'
        ) as pono,

        coalesce(
            try_to_number(nullif(trim(to_varchar(ringicreatedby)), 'NULL')),
            -1
        ) as ringicreatedby,

        coalesce(
            try_to_timestamp(podate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(podate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as podate,

        coalesce(
            try_to_timestamp(requireddate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(requireddate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as requireddate,

        coalesce(
            nullif(upper(trim(status)), 'NULL'),
            'UNK'
        ) as status,

        coalesce(
            try_to_timestamp(ringi_resubmitteddate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(ringi_resubmitteddate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as ringi_resubmitteddate,

        coalesce(
            try_to_timestamp(ringi_submitteddate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(ringi_submitteddate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as ringi_submitteddate,

        coalesce(
            try_to_timestamp(createddate, 'DD-MM-YYYY HH24:MI'),
            try_to_timestamp(createddate, 'DD-MM-YYYY'),
            to_timestamp('1900-01-01')
        ) as created_date,

        current_timestamp() as lastupdated_date

    from source

)

select *
from renamed