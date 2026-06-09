{{
    config(
        materialized='incremental',
        unique_key='id',
        incremental_strategy='merge'
    )
}}

with source_data as (
    select * from 
    {{ source('customers_stage','raw_customers')}}
)

select *
from source_data