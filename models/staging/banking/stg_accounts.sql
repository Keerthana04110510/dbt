{{    config(
             materialized='view'
    )    }}

select upper(account_number) as account_number,
       lower(account_type)as account_type,
       TO_DATE(open_date, 'DD-MM-YYYY') as open_date,
       current_timestamp as created_at,
       updated_at
FROM {{ source('stage', 'bank_accounts') }}


