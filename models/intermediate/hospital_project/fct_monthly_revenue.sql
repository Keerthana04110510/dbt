{{
    config(
        materialized='incremental',
        incremental_strategy='insert_overwrite'
    )
}}

select 
      sum(a.consultation_fee + t.treatment_cost) as monthly_revenue,
      year(a.appoinment_date) as year,
      month(a.appoinment_date) as month,
      max(a.updated_at) as updated_at,
      max(a.updated_at) as max_updated_at
      from {{ ref('stg_appoinment') }} a 
      left join {{ ref ('stg_treatment') }} t
      on a.appoinment_id = t.appoinment_id

     {% if is_incremental() %}
        where a.updated_at > (select max(max_updated_at) from {{ this }})
     {% endif %}

     group by year(a.appoinment_date),
     month(a.appoinment_date)