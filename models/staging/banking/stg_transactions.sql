{{ config(
    materialized ='table',
    database = 'demo_db',
    schema = 'public'
)}}
SELECT UPPER(txn_id ) AS txn_id,1
       account_number,
       TO_DATE(txn_date,'DD-MM-YYYY') as txn_date,
       round(amount,2) as amount,
       lower(txn_type) as txn_type,
       lower(txn_status) as txn_status,
       updated_at
from  {{ source('stage', 'bank_transactions')}}

