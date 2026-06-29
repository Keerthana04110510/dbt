{{
    config(
        materialized='table'
    )
}}

select
    cast(purchasingdocument as int) as purchasingdocument,
    cast(item as int) as int,
    ringino,
    porno,
    companycode,
    documenttype,
    vendorcode,
    purchasingorganization,
    purchasinggroup,
    paymentterm,
    cast(currency as varchar) as currency,
    conversion,
    podocument,
    materialcode,
    cast(orderquantity as int) as orderquantity,
    unitprice,
    glaccount,
    costcenter,
    materialgroup,
    plant,
    tazcode,
    hsn,
    deliverycompletionindicators,
    deletionindicator,
    grnquantity,
    totaldeliveredquantity,
    pendingtodelivered,
    freightcharges,
    cast(poramount as number(18, 2)) as poramount,
    try_to_date(nullif(deliverydate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as deliverydate,
    try_to_date(nullif(grndate, 'NULL'), 'dd-mm-yyyy hh24:mi') as grndate,
    try_to_date(nullif(createddate, 'NULL'), 'dd-mm-yyyy hh24:mi')
        as createddate

from {{ source('tdsg_source','grn_details') }}
