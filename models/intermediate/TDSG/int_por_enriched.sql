{{
    config(
        materialized='table'
    )
}}

SELECT
    por.porid,
    por.porno,
    por.departmentid,
    por.purchasinggroupid,
    por.totalamount_inr,
    por.ringi_submitteddate,
    dept.divisionkey,
    submit_dt.datekey,
    rpm.ringiid,
    emp.employeekey,
    por.ringicreatedby,
por.status,
por.pono,
por.reviseno,
por.option1,
por.option2,
por.isdeleted,
rpm.finalvendorid,
rpm.amount AS ringivalue_inr,
rm.ringino,
rm.status AS ringistatus,
po.podate,
pur.purchaserid,
pur.purchasername

FROM {{ ref('stg_stg_pormaster') }} por
LEFT JOIN {{ ref('dim_department') }} dept
ON por.departmentid = dept.departmentkey
LEFT JOIN {{ ref('dim_division') }} div
ON dept.divisionkey = div.divisionkey
LEFT JOIN {{ ref('dim_employee') }} emp
ON por.ringicreatedby = emp.employeekey
LEFT JOIN {{ ref('dim_date') }} submit_dt
ON por.ringi_submitteddate = submit_dt.fulldate
LEFT JOIN {{ ref('stg_ringipormap') }} rpm
ON por.porid = rpm.porid
LEFT JOIN {{ ref('stg_stg_ringimaster') }} rm
ON rpm.ringiid = rm.ringikey
LEFT JOIN {{ ref('stg_prd_pomaster') }} po
ON por.pono = po.ponumber
LEFT JOIN {{ ref('stg_purchaserhandlingdivision_prd') }} pur
    ON div.divisionname = pur.division
   AND dept.departmentname = pur.department
   AND por.ringi_submitteddate BETWEEN
       CAST(pur.fromdate AS DATE)
       AND COALESCE(CAST(pur.todate AS DATE), DATE '9999-12-31')