select store_id, product_id, count(*) as nb
from {{ ref('int_stocks_enriched') }}
group by store_id, product_id
having count(*) > 1