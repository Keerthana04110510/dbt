select * from 
{{  ref('stg_appoinment')  }}
where appoinment_date > current_timestamp()