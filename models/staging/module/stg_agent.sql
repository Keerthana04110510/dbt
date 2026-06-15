{{
    config(
        materialized='table'
    )
}}

select *, (commission_rate *100) as commission_pct,
        cast(is_active as boolean) as is_active_agent
        from {{ source('insurance_raw','raw_agent') }}