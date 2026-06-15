select * from 
{{ ref('stg_payments')}}
where payment_amount is null or 
      payment_amount=0