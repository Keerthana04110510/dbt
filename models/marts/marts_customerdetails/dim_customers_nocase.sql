{{
    config(
        materialized='incremental',
        unique_key='id',
        incremental_strategy='merge'
    )
}}

with source_data as (
    select * from
    {{ ref('stg_r_customers')}}
)
{% if is_incremental() %}
, final as (
    select s.*,
    coalesce(t.created_at, current_timestamp()) AS created_at,
    case 
        when t.id is null
        then null
        when upper(s.name) <> upper(t.name)
        then current_timestamp()
        else t.updated_at
        end as updated_at
    from source_data s
    left join {{ this }} t
    on s.id=t.id
)
{% else %}
, final as (
    select s.*,
    current_timestamp as created_at,
    null as updated_at
    from source_data s
)

{% endif %}
select * from final