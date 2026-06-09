{{ config(materialized='view')}}

select p.sku AS product_id,
       p.name AS product_name,
       