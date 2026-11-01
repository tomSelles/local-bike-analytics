with

source as (
    select * from {{ source('local_bike', 'customers') }}
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        nullif(phone, 'NULL') as phone,
        email,
        street,
        city,
        state,
        lpad(cast(zip_code as string), 5, '0') as zip_code

    from source
)

select * from renamed