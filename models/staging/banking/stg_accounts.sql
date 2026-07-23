{{    config(
             materialized='table'
    )    }}



select
    updated_at,
    upper(account_number) as account_number,
    lower(account_type) as account_type,
    to_date(open_date, 'DD-MM-YYYY') as open_date,
    current_timestamp() as created_at
from {{ source('stages_bank','bank_transactions') }}


