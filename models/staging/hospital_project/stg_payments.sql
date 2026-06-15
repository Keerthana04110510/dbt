{{
    config(
        materialized='table'
    )
}}

select payment_id AS payment_id,
       APPOINTMENT_ID AS appoinment_id,
       payment_amount AS payment_amount,
       payment_mode AS paymnet_mode,
       payment_status AS payment_status,
       to_timestamp(payment_date, 'dd-mm-yyyy') AS payment_date,
       to_timestamp(updated_at, 'dd-mm-yyyy') AS updated_at
 from {{ source('raw_hospital', 'hp_payments')}}