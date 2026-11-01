select order_id, item_id, count(*) as nb
from {{ ref('int_order_items_enriched') }}
group by order_id, item_id
having count(*) > 1