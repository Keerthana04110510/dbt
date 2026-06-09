{{ config(materialized='ephemeral') }}

select
    a.account_number,
    t.txn_date,
    SUM(amount) as total_amount,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END)as credit_amount,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END)as debit_amount
from {{ ref('stg_transactions') }} t 
left join {{ ref('stg_accounts') }} a
ON a.account_number = t.txn_id
group by 
    a.account_number,
    t.txn_date
    