select * from 
{{ ref('stg_e_customers')}}
where signup_date > current_date()