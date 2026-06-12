{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

select customer_id,
       customer_name,
       customer_city,
       customer_state,
       customer_email,
       customer_status,
       signup_date,
       {{ generate_surrogate_key(['customer_id']) }} AS customer_sk
       from {{ ref('int_sales_enriched')}}
