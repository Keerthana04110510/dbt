{{  config( materialized ='incremental',
    unique_key='account_sk',
    incremental_strategy='merge')  }}

select md5(account_number) as account_sk,
       lower(account_type)as account_type,
       TO_DATE(open_date, 'DD-MM-YYYY') as open_date,
       current_timestamp as created_at
FROM {{ ref('stg_accounts')}}
{% if is_incremental() %}
where  updated_at > (select max(updated_at) from {{this}})
{% endif %}
