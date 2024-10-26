with stg_orders as (
    select
        orderid,  
        {{ dbt_utils.generate_surrogate_key(['employeeid']) }} as employeekey, 
        {{ dbt_utils.generate_surrogate_key(['customerid']) }} as customerkey, 
        replace(to_date(orderdate)::varchar,'-','')::int as orderdatekey
    from {{source('northwind','Orders')}}
),
stg_order_details as (
    select 
        orderid,
        {{ dbt_utils.generate_surrogate_key(['productid']) }} as productkey,
        quantity, 
        quantity * UnitPrice as extendedpriceamount,
        quantity * UnitPrice * Discount as discountamount,
        quantity * UnitPrice * (1 - Discount) as soldamount
    from {{source('northwind','Order_Details')}}
)
select  
    o.orderid, 
    o.customerkey,
    o.employeekey,
    o.orderdatekey,
    od.productkey,
    od.quantity,
    od.extendedpriceamount,
    od.discountamount,
    od.soldamount
from stg_orders o
join stg_order_details od on o.orderid = od.orderid