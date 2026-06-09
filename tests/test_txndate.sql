select *
from {{ ref('fct_transactions') }} t
join {{ ref('dim_account') }} a
  on t.account_sk = a.account_sk
where a.open_date > t.txn_date