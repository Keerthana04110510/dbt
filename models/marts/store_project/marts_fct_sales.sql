{{
    config(
        materialized='incremental',
        unique_key=['order_id', 'product_id']
    )
}}

select
    *,
    case
        when dbt_valid_to is null
            then 'Y'
        else 'N'
    end as current_flag
from
    {{ ref('snap_customers') }}



