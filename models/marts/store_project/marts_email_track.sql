{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='customer_id'
    )
}}

with source_data as (
    select
        distinct customer_id,
        customer_name,
        customer_email,
        customer_city,
        customer_state,
        customer_status,
        signup_date,
        customer_sk
    from {{ ref('dim_store_customers') }}

)

{% if is_incremental() %}

    , final as (
        select
            s.customer_id,
            s.customer_name,
            s.customer_email,
            s.customer_city,
            s.customer_state,
            s.customer_status,
            s.signup_date,
            s.customer_sk,
            coalesce(t.created_at, current_timestamp()) as created_at,
            case
                when s.customer_email is null
                    then null
                when s.customer_email <> t.customer_email
                    then current_timestamp()
                else t.last_updated_at
            end as last_updated_at
        from source_data as s
        left join {{ this }} as t
            on s.customer_id = t.customer_id
    )

{% else %}

, final AS ( 
    select 
       customer_id,
       customer_name,
       customer_email,
       customer_city,
       customer_state,
       customer_status,
       signup_date,
       customer_sk,
       current_timestamp() AS created_at,
       null as last_updated_at
     from source_data
)

{% endif %}

select * from final
