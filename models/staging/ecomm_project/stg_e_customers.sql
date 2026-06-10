{{
    config(
        materialized='table'
    )
}}

select customer_id,
       customer_name AS customer_full_name,
       lower(email) AS email,
       city,
       signup_date,
       upper(status) AS status,
       {{ surrogate_key(['customer_id']) }} AS customer_sk
    from {{ source('ecomm_stage','ecomm_customers')}}