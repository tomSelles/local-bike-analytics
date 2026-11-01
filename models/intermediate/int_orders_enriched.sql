with

orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('int_order_items_enriched') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

staffs as (
    select * from {{ ref('stg_staffs') }}
),

-- 1. Agréger les lignes au grain commande
order_totals as (
    select
        order_id,
        count(*) as nb_lines,
        sum(quantity_sold) as total_quantity,
        sum(gross_revenue) as order_gross_revenue,
        sum(discount_amount) as order_discount_amount,
        sum(net_revenue) as order_net_revenue

    from order_items
    group by order_id
),

-- 2. Joindre les totaux aux commandes
joined as (
    select
        orders.order_id,
        orders.customer_id,
        orders.store_id,
        orders.staff_id,
        stores.store_name,
        concat(staffs.first_name, ' ', staffs.last_name) as staff_name,
        orders.order_status,
        orders.is_shipped,
        orders.order_date,
        orders.required_date,
        orders.shipped_date,
        order_totals.nb_lines,
        order_totals.total_quantity,
        order_totals.order_gross_revenue,
        order_totals.order_discount_amount,
        order_totals.order_net_revenue

    from orders
    left join order_totals
        on orders.order_id = order_totals.order_id
    left join stores
        on orders.store_id = stores.store_id
    left join staffs
        on orders.staff_id = staffs.staff_id
),

-- 3. Calculs au grain commande
final as (
    select
        *,
        date_diff(required_date, order_date, day) as promised_lead_days,
        date_diff(shipped_date, order_date, day) as shipping_days,
        shipped_date > required_date as is_late,
        row_number() over (
            partition by customer_id
            order by order_date, order_id
        ) as customer_order_rank,
        row_number() over (
            partition by customer_id
            order by order_date, order_id
        ) > 1 as is_repeat_order

    from joined
)

select * from final