{{
    config(
        materialized='table'
    )
}}

select claim_id,
       policy_id,
       customer_id,
       claim_number,
       claim_amount as gross_claim_amount,
       approved_amount as net_approved_amount,
       (approved_amount- deductible) as net_claim_payout,
       try_to_date(claim_date) as claim_date,
       claim_type,
       claim_status,
       deductible,
       adjuster_id,
       description,
       resolution_date,
       try_to_date(created_at) as created_at,
       try_to_date(updated_at) as updated_at,
       try_to_date(incident_date) as incident_date,
       case when claim_status = 'Approved'
            then True
            else False
       end as is_approved,
       datediff(
            day,
            try_to_date(resolution_date),
            try_to_date(claim_date)
        ) as policy_duration_days,
       case when approved_amount <3000
            then 'low'
            when approved_amount between 3000 and 1000 
            then 'medium'
            else 'high'
        end as severity_tier
     from {{ source('insurance_raw','raw_claims')}}
       
