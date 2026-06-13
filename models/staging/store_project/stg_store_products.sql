{{
    config(
        materialized='table'
    )
}}

select  product_id AS product_id,
        product_name AS product_name,
        category AS product_category,
        subcategory AS product_subcategory,
        price AS price,
        product_status AS product_status,
        cast(last_updated_at AS DATE) AS last_updated_at
from {{ source('store_stage','store_products') }}

