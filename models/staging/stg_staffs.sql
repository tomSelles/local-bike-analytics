with

source as (
    select * from {{ source('local_bike', 'staffs') }}
),

renamed as (
    select
        staff_id,
        store_id,
        safe_cast(nullif(manager_id, 'NULL') as int64) as manager_id,
        first_name,
        last_name,
        email,
        phone,
        active = 1 as is_active

    from source
)

select * from renamed