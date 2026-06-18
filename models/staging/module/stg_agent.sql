{{
    config(
        materialized='table'
    )
}}

select *, concat(to_varchar(round(commission_rate * 100, 2)), '%') as commission_pct,
          datediff(
            day,
            try_to_date(hire_date),
            current_timestamp()
        ) as tenure_years,
        cast(is_active as boolean) as is_active_agent
        from {{ source('insurance_raw','raw_agent') }}