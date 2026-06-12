{{
    config(
        materialized='table'
    )
}}

select distinct customer_id,
       {{ generate_surrogate_key(['customer_id', 'email']) }}
       customer_name,
       email AS customer_email,
       city AS customer_city,
       state AS customer_state,
       {{ standardize_status('customer_status') }} AS customer_status,
       CAST(signup_date as DATE) AS signup_date,
       cast(last_updated_at as DATE) AS last_updated_at,
       current_timestamp() AS dbt_loaded_at
from  {{ source ('store_stage', 'store_customers')}}