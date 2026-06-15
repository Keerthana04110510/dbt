{{
    config(
        materialized='incremental',
        unique_key='fact_visit_sk',
        pre_hook= "
        insert into audit_logs
        (
        model_name,
        start_time,
        status
        )
        values(
        'fct_hospital_visits',
        current_timestamp(),
        'started'
        )
        ",
        post_hook="
        update audit_logs
        set end_time=current_timestamp(),
        status='completed' 
        where model_name='fct_hospital_visits' 
        "
    )
}}

select  {{  generate_surrogate_key(['a.appoinment_id','p.patient_id','d.doctor_id']) }} AS fact_visit_sk,
        p.patient_sk,
        d.doctor_sk,
        p.patient_id,
        p.patient_name,
        p.city,
        p.insurance_type,
        (t.treatment_cost + a.consultation_fee ) AS total_hospital_revenue,
        t.treatment_cost AS net_treatment_revenue
       from {{ ref('dim_h_patient')}} p
       left join {{ ref('stg_appoinment')}} a
       on p.patient_id= a.patient_id
       left join {{ ref('dim_doctore')}} d 
       on a.doctor_id=d.doctor_id
       left join {{ ref('stg_treatment')}} t 
       on a.appoinment_id=t.appoinment_id
