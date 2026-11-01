with

stocks as (
    select * from {{ ref('int_stocks_enriched') }}
),

order_items as (
    select * from {{ ref('int_order_items_enriched') }}
),

sales_12m as (
    select
        store_id,
        product_id,
        sum(quantity_sold) as units_sold_12m

    from order_items
    where is_shipped
      and order_date between '2017-04-01' and '2018-03-31'
    group by store_id, product_id
),

joined as (
    select
        stocks.*,
        coalesce(sales_12m.units_sold_12m, 0) as units_sold_12m,
        coalesce(sales_12m.units_sold_12m, 0) / 12 as avg_monthly_units

    from stocks
    left join sales_12m
        on stocks.store_id = sales_12m.store_id
       and stocks.product_id = sales_12m.product_id
),

final as (
    select
        *,
        safe_divide(stock_quantity, avg_monthly_units) as coverage_months,
        case
            when model_year = 2019 then 'new_product'
            when stock_quantity = 0 and units_sold_12m > 0 then 'stockout_risk'
            when stock_quantity > 0 and units_sold_12m = 0 then 'dormant_stock'
            when safe_divide(stock_quantity, avg_monthly_units) > 12 then 'overstock'
            else 'ok'
        end as stock_status

    from joined
)

select * from final