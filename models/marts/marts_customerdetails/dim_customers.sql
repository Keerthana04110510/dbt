{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id'
    )
}}

with source_data as ( 
        select * from 
        {{ ref('stg_r_customers')}}
)
{% if is_incremental() %}
,final as (
        select s.*,
        s.id AS customer_id,
        s.name AS customer_name,
        coalesce(t.created_at,current_timestamp()) AS created_at,
        case when customer_id is null
             then null
             when s.name<>t.customer_name
             then current_timestamp()
             else t.dbt_updated_at
             end as dbt_updated_at
        from source_data s
        left join {{this}} t
        on s.id=t.customer_id
)
{% else %}
,final as(
       select s.*,
       s.id AS customer_id,
       s.name AS customer_name,
       current_timestamp() AS created_at,
       null as dbt_updated_at
       from source_data s
)
{% endif %}
select * from final