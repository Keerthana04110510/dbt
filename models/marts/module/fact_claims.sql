{{
    config(
        materialized='incremental',
        unique_key='claim_surrogate_key',
        incremental_strategy='merge'
    )
}}
 
select
    {{ generate_surrogate_key(['claim_id','policy_id']) }}
        as claim_surrogate_key,
    claim_id,
    policy_id,
    customer_id,
    claim_date,
    claim_type,
    claim_status,
    severity_tier,
    gross_claim_amount,
    net_approved_amount,
    is_approved,
    current_timestamp() as dbt_updated_at,
    '{{ invocation_id }}' as dbt_run_id
from {{ ref('stg_claims') }}
 
{% if is_incremental() %}
where  updated_at >
    (
        SELECT MAX(dbt_updated_at)
        FROM {{ this }}
    )
 
{% endif %}