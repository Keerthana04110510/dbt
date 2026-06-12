{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key= 'product_id'
    )
}}

select 
       {{ generate_surrogate_key(['product_id']) }} AS product_sk,
       product_id,
       product_name,
       product_category,
       price,
       product_status,
       product_updated_at
       from {{ ref('int_sales_enriched') }} 