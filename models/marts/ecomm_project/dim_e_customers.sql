{{
    config(
        materialized='incremental',
        unique_key='customer_id',
        incremental_strategy='merge'
    )
}}

with source_data as (select 
      {{ surrogate_key(['customer_id']) }} AS customer_sk,
      customer_id,
      customer_full_name,
      city,
      email,
      status,
      signup_date
      from {{ ref('int_order_details')}}
      
        qualify row_number() over (
        partition by customer_id 
        order by signup_date desc)=1

)

{% if is_incremental() %}
, final as (
    select s.customer_sk,
           s.customer_id,
           s.city,
           s.email,
           s.status,
           s.signup_date,
           coalesce(t.created_at, current_timestamp()) AS created_at,
           case
               when t.customer_id is null
               then null
               when s.customer_id <> t.customer_id
               then current_timestamp()
               else t.updated_at
               end AS updated_at
     from source_data s
     left join {{ this }} t 
     on s.customer_id=t.customer_id
)

{% else %}
, final as (
          select customer_sk,
           customer_id,
           city,
           email,
           status,
           signup_date,
           current_timestamp() AS created_at,
           null AS updated_at
           from source_data
)

{% endif %}

select * from final
  