select category_name, brand_name, order_month, count(*) as nb
from {{ ref('mart_category_sales') }}
group by category_name, brand_name, order_month
having count(*) > 1