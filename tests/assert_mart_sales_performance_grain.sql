select store_id, order_month, count(*) as nb
from {{ ref('mart_sales_performance') }}
group by store_id, order_month
having count(*) > 1