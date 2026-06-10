{{
    config(
        materialized='table'
    )
}}

select * from 
{{ source('ecomm_stage','ecomm_products')}}