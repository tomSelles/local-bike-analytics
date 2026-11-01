with 

order_items as (
    select * from {{ ref('stg_order_items') }}
), 

orders as (
    select * from {{ ref('stg_orders') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

brands as (
    select * from {{ ref('stg_brands') }}
),

categories as (
    select * from {{ ref('stg_categories') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

joined as (
    select
        -- clés
        order_items.order_id,
        order_items.item_id,

        -- commande
        orders.order_date, 
        orders.order_status, 
        orders.is_shipped, 
        orders.customer_id, 
        orders.store_id, 
        orders.staff_id,
        stores.store_name, 
        -- produit
        products.product_id, 
        products.product_name, 
        products.model_year,
        brands.brand_name,
        categories.category_name,
        -- mesures brutes, renommées
        order_items.quantity as quantity_sold,
        order_items.list_price as unit_price,
        order_items.discount as discount_rate

    from order_items
    inner join orders
        on order_items.order_id = orders.order_id
    left join products
        on order_items.product_id = products.product_id
    left join brands
        on products.brand_id = brands.brand_id
    left join categories
        on products.category_id = categories.category_id
    left join stores
        on orders.store_id = stores.store_id
),

final as (
    select
        *,
        quantity_sold * unit_price as gross_revenue,
        quantity_sold * unit_price * discount_rate as discount_amount,
        quantity_sold * unit_price * (1 - discount_rate) as net_revenue

    from joined
)

select * from final