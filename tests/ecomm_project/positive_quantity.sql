select quantity 
from {{ ref('stg_e_orders')}}
where quantity < 0