{{
    config(
        materialized='incremental'
    )
}}

select  *,
      case 
          when dbt_valid_to is null
          then 'Y'
          else 'N'
          end as current_record_flag
      from {{ ref('snap_customer')  }}
      order by id, dbt_valid_from