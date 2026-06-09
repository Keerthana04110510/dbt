{{ config(
    materialized='incremental') }}

SELECT
    C1 AS policyid,
    C2 AS customerid,
    C3 AS producttype,
    C4 AS insurance_partner,
    C5 AS premium_amount,
    C6 AS policy_status,
    C7 AS issue_date
FROM {{ source('stage', 'policies') }}
{% if is_incremental() %}
WHERE C1 != 'PolicyID' and issue_date > (select max(issue_date) from {{this}})
{% endif %}
