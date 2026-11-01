with

orders as (
    select * from {{ ref('int_orders_enriched') }}
),

monthly as (
    select
        store_id,
        store_name,
        date_trunc(order_date, month) as order_month,
        count(*) as nb_orders,
        count(distinct staff_id) as nb_active_sellers,
        sum(order_gross_revenue) as gross_revenue,
        sum(order_discount_amount) as discount_amount,
        sum(order_net_revenue) as net_revenue

    from orders
    where is_shipped
    group by store_id, store_name, order_month
),

final as (
    select
        monthly.order_month,
        monthly.store_id,
        monthly.store_name,
        monthly.nb_orders,
        monthly.nb_active_sellers,
        monthly.gross_revenue,
        monthly.discount_amount,
        monthly.net_revenue,
        safe_divide(monthly.net_revenue, monthly.nb_orders) as avg_basket,
        safe_divide(monthly.discount_amount, monthly.gross_revenue) as discount_rate,
        safe_divide(monthly.net_revenue, monthly.nb_active_sellers) as net_revenue_per_seller

    from monthly
)

select * from final