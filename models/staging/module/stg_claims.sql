{{
    config(
        materialized='table'
    )
}}

select claim_amount as gross_claim_amount,
       approved_amount as net_approved_amount,
       (approved_amount- deductible) as net_claim_payout,
       resolution_date,
       claim_date,
       case when claim_status = 'Approved'
            then 'true'
            else 'false'
       end as is_approved,
       case when approved_amount <3000
            then 'low'
            when approved_amount between 3000 and 1000 
            then 'medium'
            else 'high'
        end as severity_tier
     from {{ source('insurance_raw','raw_claims')}}
       
