{{ config(materialized='table') }}

SELECT md5(concat(
       initcap(NAME),
       coalesce(AGE,0),
       TO_DATE(DATE_OF_ADMISSION,'DD-MM-YYYY'))) AS unique_field,
       DATE_OF_ADMISSION,
       coalesce(GENDER,null) AS GENDER,
       BLOOD_TYPE,
       MEDICAL_CONDITION,
       initcap(DOCTOR) AS DOCTOR,
       initcap(HOSPITAL) AS HOSPITAL,
       INSURANCE_PROVIDER, 
       round(BILLING_AMOUNT,3) AS BILLING_AMOUNT,
       ROOM_NUMBER,
       coalesce(ADMISSION_TYPE,null) AS ADMISSION_TYPE,
       TO_DATE(DISCHARGE_DATE,'DD-MM-YYYY') AS DISCHARGE_DATE,
       MEDICATION,
       TEST_RESULTS
from {{ ref('stg_health_care') }}

QUALIFY ROW_NUMBER() OVER (
    PARTITION BY UNIQUE_FIELD
    ORDER BY DATE_OF_ADMISSION DESC
) = 1
