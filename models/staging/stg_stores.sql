with

source as (
    select * from {{ source('local_bike', 'stores') }}
),

renamed as (
    select
        store_id,
        store_name,
        phone,
        email,
        street,
        city,
        state,
        lpad(cast(zip_code as string), 5, '0') as zip_code
           
    from source
)

select * from renamed