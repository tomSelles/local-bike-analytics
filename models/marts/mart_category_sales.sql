with

order_items as (
    select * from {{ ref('int_order_items_enriched') }}
),

final as (
    select
        date_trunc(order_date, month) as order_month,
        extract(year from order_date) as order_year,
        extract(month from order_date) as order_month_number,
        category_name,
        brand_name,
        sum(quantity_sold) as units_sold,
        sum(net_revenue) as net_revenue,
        count(distinct order_id) as nb_orders

    from order_items
    where is_shipped
    group by order_month, order_year, order_month_number, category_name, brand_name
)

select * from final