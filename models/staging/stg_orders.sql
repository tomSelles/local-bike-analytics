with

source as (
    select * from {{ source('local_bike', 'orders') }}
),

renamed as (
    select
        order_id,
        customer_id,
        store_id,
        staff_id,
        order_status,
        order_date,
        required_date,
        safe_cast(nullif(shipped_date, 'NULL') as date) as shipped_date,
        safe_cast(nullif(shipped_date, 'NULL') as date) is not null as is_shipped

    from source
)

select * from renamed