with

orders as (
    select * from {{ ref('int_orders_enriched') }}
),

final as (
    select
        order_id,
        order_date,
        date_trunc(order_date, month) as order_month,
        customer_id,
        store_id,
        store_name,
        staff_id,
        staff_name,
        order_status,
        is_shipped,
        is_late,
        promised_lead_days,
        shipping_days,
        customer_order_rank,
        is_repeat_order,
        order_net_revenue

    from orders
)

select * from final