{{
    config(
        materialized='incremental',
        unique_key='doctor_id'
    )
}}

select *, case
              when dbt_valid_to is null
              then 'y'
              else 'n'
          end AS current_flag
    from {{ ref('snap_doctor') }}