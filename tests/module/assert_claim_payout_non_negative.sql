select * from 
{{ ref('stg_claims')}}
where claim_net_payout < 0