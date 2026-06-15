{{
    config(
        materialized='table'
    )
}}

select APPOINTMENT_ID AS appoinment_id,
       patient_id AS patient_id,
       doctor_id AS doctor_id,
       to_timestamp(APPOINTMENT_DATE,'dd-mm-yyyy') AS appoinment_date,
       status AS status,
       consultation_fee AS consultation_fee,
       to_timestamp(updated_at,'dd-mm-yyyy') AS updated_at
    from {{ source('raw_hospital','hp_appoinment')}}