
{{ config(materialized='table') }}

SELECT
    customerid,
    COUNT(customerid) AS total_policies
FROM {{ ref('int_customer_policies') }}
GROUP BY customerid