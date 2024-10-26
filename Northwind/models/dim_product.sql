with stg_products as (
    select 
        p.productid, 
        p.productname, 
        p.supplierid as supplierkey, 
        c.categoryname, 
        c.description as categorydescription
    from {{ source('northwind', 'Products') }} p
    left join {{ source('northwind', 'Categories') }} c
        on p.categoryid = c.categoryid
)
select  
    {{ dbt_utils.generate_surrogate_key(['stg_products.productid']) }} as productkey,
    stg_products.*
from stg_products