select count(item_name)
from {{ ref('stg_orders')}}
group by item_name
having count(item_name)<0