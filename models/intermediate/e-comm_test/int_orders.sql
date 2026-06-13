{{
    config(
        materialized='view'
    )
}}

select order_id AS order_id, 
       status AS status,
      case 
          when price > 400
          then price - price * 10/100
          when price > 250
          then price - price * 5/100
          else price
       end as price,
       {{ surrogate_key(['order_id']) }} AS order_sk,
       {{ final_price('price') }} AS final_price,
       case 
           when dbt_valid_to is null
           then 'Y'
           else 'N'
       end as CURRENT_RECORD_FLAG
       from {{ ref('snap_orders')}}
