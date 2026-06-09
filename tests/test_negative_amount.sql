select * from {{ ref('fct_transactions') }}
where upper(txn_type) = 'withdraw' and amount > 0