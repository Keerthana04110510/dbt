{{
    config(
        materialized='table'
    )
}}
with source_data as (

    select *,
        row_number() over (
            partition by policy_id
            order by updated_at desc
        ) as rn
    from {{ ref('stg_policies') }}

),

final as (

    select
        policy_id,
        policy_number,
        policy_type,
        status,
        premium_amount,
        coverage_amount,
        start_date,
        end_date,
        is_active_policy
    from source_data
    where rn = 1

)

select
    md5(cast(policy_id as varchar)) as policy_dim_key,
    policy_id,
    policy_number,
    policy_type,
    status,
    premium_amount,
    coverage_amount,
    start_date,
    end_date,
    is_active_policy,
    current_timestamp() as dbt_updated_at,
    'stg_policies' as record_source

from final
