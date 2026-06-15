{{
    config(
        materialized='incremental',
        unique_key='claim_surrogate_key',
        incremental_strategy='merge'
    )
}}

with source_data as(
select {{ generate_surrogate_key(['claim_id','policy_id']) }} as claim_surrogate_key,
        claim_id,
        policy_id,
        customer_id,
        claim_date,
        claim_type,
        claim_status,
        severity_tier,
        gross_claim_amount,
        net_approved_amount,
        claim_net_payout 
        from {{ ref('int_policy_claims_joined') }}

        {% if is_incremental() %}
            where updated_at > (select max(dbt_updated_at) from {{ this }}) 
        {% endif %}
)
, final as (
        s.claim_surrogate_key,
        s.claim_id,
        s.policy_id,
        s.customer_id,
        s.claim_date,
        s.claim_type,
        s.claim_status,
        s.severity_tier,
        s.gross_claim_amount,
        s.net_approved_amount,
        s.claim_net_payout,
        current_timestamp() as dbt_updated_at

        from source_data

)

select * from final