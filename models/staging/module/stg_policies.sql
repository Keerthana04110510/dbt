{{
    config(
        materialized='table'
    )
}}

select  policy_id,
        customer_id,
        policy_number,
        policy_type,
        try_to_date(start_date) as start_date,
        try_to_date(end_date) as end_date,
        created_at,
        updated_at,
        datediff(
            day,
            try_to_date(start_date),
            try_to_date(end_date)
        ) as policy_duration_days,
        status,
        agent_id,
        cast(premium_amount as numeric(12,2)) as premium_amount,
        cast(coverage_amount  as numeric(12,2)) as coverage_amount,
        current_timestamp() as loaded_at,
        'insurance_core' AS source_system,
        case when status = 'Active'
             then True
             else False
        end as is_active_policy
        from {{ source('insurance_raw','raw_policies') }}