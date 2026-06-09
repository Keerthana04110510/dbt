{{
    config(
        materialized='view'
        )
}}
select c.id AS customer_id, 
       {{ replace_values('c.name', 'unknown') }} AS customer_name,
       o.id AS order_id,
       o.ordered_at AS order_date,
       {{ new_tax('o.tax_paid',2) }} AS New_tax,
       o.tax_paid
    from {{ ref('stg_r_customers') }} c 
    left join {{ ref('stg_r_orders') }} o
    on c.id=o.customer

    