{{
    config(
        materialized='incremental',
        unique_key='customer_id'
    )
}}

select *,
       dbt_valid_from AS start_date,
       dbt_valid_to AS end_date,
       case 
           when dbt_valid_to is null
           then 'Y'
           else 'N'
        end as current_flag
        from {{ ref('snap_sales')}}