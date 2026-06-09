with 

source as (

    select * from {{ source('stage', 'bank_accounts') }}

),

renamed as (

    select
        account_number,
        customer_id,
        account_type,
        open_date,
        balance,
        updated_at

    from source

)

select * from renamed