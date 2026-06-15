{{
    config(
        materialized='table'
    )
}}
select  *, concat('first_name','last_name') as full_name,
         case when gender='M'
            then 'Male'
            when  gender='F'
            then 'Female'
            else 'unknown'
         end as gender_label,
         current_timestamp() as loaded_at
    from {{ source('insurance_raw','raw_customers') }}