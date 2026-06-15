{{
    config(
        materialized='incremental',
        unique_key='appoinment_id',
        incremental_strategy='append'
    )
}}

select * from 
{{ ref('stg_appoinment') }}

{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where updated_at > (select max(updated_at ) from {{ this }}) 
{% endif %}