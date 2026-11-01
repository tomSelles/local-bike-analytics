with

stocks as (
    select * from {{ ref('stg_stocks') }}
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

final as (
    select
        stocks.store_id,
        stocks.product_id,
        stores.store_name,
        products.product_name,
        products.model_year,
        products.list_price,
        brands.brand_name,
        categories.category_name,
        stocks.quantity as stock_quantity,
        stocks.quantity * products.list_price as stock_value

    from stocks
    left join products
        on stocks.product_id = products.product_id
    left join brands
        on products.brand_id = brands.brand_id
    left join categories
        on products.category_id = categories.category_id
    left join stores
        on stocks.store_id = stores.store_id
)

select * from final