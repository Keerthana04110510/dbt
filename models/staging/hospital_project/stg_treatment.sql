{{
    config(
        materialized='table'
    )
}}

select treatment_id AS treatment_id,
       APPOINTMENT_ID AS appoinment_id,
       treatment_type AS treatment_type,
       treatment_cost AS treatment_cost,
       treatment_status AS treatment_status,
       to_timestamp(updated_at, 'dd-mm-yyyy') AS updated_at
from {{ source('raw_hospital', 'hp_treatments')}}