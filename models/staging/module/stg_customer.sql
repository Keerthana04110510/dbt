{{
    config(
        materialized='table'
    )
}}
select
    customer_id,
    email,
    phone,
    address,
    city,
    state,
    zip_code,
    credit_score,
    risk_tier,
    gender,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    try_to_date(date_of_birth) as date_of_birth,
    try_to_date(customer_since) as customer_since,
    try_to_date(created_at) as created_at,
    try_to_date(updated_at) as updated_at,
    concat('first_name', 'last_name') as full_name,
    case
        when gender = 'M'
            then 'Male'
        when gender = 'F'
            then 'Female'
        else 'unknown'
    end as gender_label,
    datediff(
        year,
        try_to_date(date_of_birth),
        current_timestamp()
    ) as customer_age,
    case
        when
            datediff(
                year,
                try_to_date(date_of_birth),
                current_timestamp()
            ) < 30
            then 'Youth'

        when
            datediff(
                year,
                try_to_date(date_of_birth),
                current_timestamp()
            ) between 30 and 60
            then 'Adult'

        else 'Senior'
    end as age_band,
    coalesce (credit_score < 650 or risk_tier = 'High', false) as is_high_risk,
    current_timestamp() as loaded_at
from {{ source('insurance_raw','raw_customers') }}
