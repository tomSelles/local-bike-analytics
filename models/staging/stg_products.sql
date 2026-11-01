with

source as (
    select * from {{ source('local_bike', 'products') }}
),

renamed as (
    select
        product_id,
        brand_id,
        category_id,
        product_name,
        model_year,
        list_price

    from source
)

select * from renamed