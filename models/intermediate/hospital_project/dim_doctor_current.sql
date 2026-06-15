{{
    config(
        materialized='incremental',
        unique_key='doctor_id',
        incremental_strategy='merge'
    )
}}

with source_data as (select * from {{'stg_doctors'}}),

final AS (SELECT sd.*, 
    {% if is_incremental() %}
    case when t.doctor_id is null then current_timestamp()
    else t.created_at_warehouse
    end as created_at_warehouse,
    {% else %}
    current_timestamp() as created_at_warehouse,
    {% endif %}
    current_timestamp() as updated_at_warehouse

 from source_data sd 
            {% if is_incremental() %}
            left join {{this}} t
            on sd.doctor_id = t.doctor_id
            {% endif %})
            
select * from final
{% if is_incremental() %}
    -- this filter will only be applied on an incremental run
    where updated_at > (select max(updated_at) from {{ this }}) 
{% endif %}