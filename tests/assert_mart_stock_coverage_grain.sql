select store_id, product_id, count(*) as nb
from {{ ref('mart_stock_coverage') }}
group by store_id, product_id
having count(*) > 1