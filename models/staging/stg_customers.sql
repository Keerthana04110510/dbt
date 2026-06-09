
{{ config(materialized='view') }}

SELECT
    CustomerId,
    upper(customername) AS customer_name,   
    LOWER(gender) AS Gender           
FROM {{ source('stage', 'customers') }}

