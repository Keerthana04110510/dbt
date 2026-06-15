{{
    config(
        materialized='ephemeral'
    )
}}

select  p.*,
        cm.*,
        cr.*,
        (cm.net_approved_amount/cm.gross_claim_amount) as loss_ratio,
        count(cm.claim_id) as claim_frequency,
        case when claim_frequency >=2
        then 'high_frequency'
        else 'normal' 
        end as claim_trend
        from {{ ref('stg_policies')}} p
        left join {{ ref('stg_claims')}} cm
        on p.policy_id = cm.policy_id
        left join {{ ref('stg_customer')}} cr
        on p.customer_id= cr.customer_id
        left join {{ ref('stg_agent') }} a
        on p.agent_id=a.agent_id