{{
    config(
        materialized='incremental',
        unique_key='patient_id',
        incremental_strategy='merge'
    )
}}

with source_data as (
    select * from 
    {{ ref('stg_patients') }}
)

, hashed_data as (
    select  *, 
           md5(concat(
            coalesce(patient_name,''),'|',
            coalesce(gender,''),'|',
            coalesce(city,''),'|',
            coalesce(insurance_type,''),'|'
           )) as hash_data
    from source_data
)

{% if is_incremental() %}
, final as (
    select s.*,
           coalesce(t.created_at,current_timestamp()) as created_at,
           case 
               when t.patient_id is null
               then null
               when s.hash_data <> t.hash_data
               then current_timestamp()
               else t.dbt_updated_at 
            end as updated_at
        from hashed_data s
        left join {{ this }} t
        on s.patient_id=t.patient_id       
)

{% else %}

,final as (
    select s.*,
           current_timestamp() as created_at,
           null as dbt_updated_at
           from hashed_data s
)
{% endif %}

select * from final 
