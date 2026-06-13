{{
    config(
        materialized='incremental',
        unique_key='order_id'
    )
}}

select
    *, {{ generate_surrogate_key(['customer_status', 'customer_city', 'customer_state']) }} AS customer_sk,
    case
        when dbt_valid_to is null
            then 'Y'
        else 'N'
    end as current_flag
from
    {{ ref('snap_sales') }}