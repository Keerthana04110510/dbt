{{
    config(
        materialized='ephemeral'
    )
}}

select  p.*,
        p.policy_id as policy_pid,
        p.customer_id as customer_pid,
        p.agent_id as agent_pid,
        p.updated_at as updated_pat
        cm.*,
        cm.policy_id as policy_cmid,
        cm.updated_at as updated_cmat,
        cr.*,
        cr.customer_id as customer_crid,
        cr.updated_at as updated_crat,
        a.*,
        a.agent_id as agent_aid,
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