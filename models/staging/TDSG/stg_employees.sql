{{
    config(
        materialized='table'
    )
}}

select
    cast(employeekey as int) as employeekey,
    cast(departmentkey as int) as departmentkey,
    cast(reportingmanagerkey as int) as reportingmanagerkey,
    plantkey,
    employeecode,
    costcenter,
    isadmin,
    email,
    empdesignation,
    isvendorsync,
    employeetype,
    roleid,
    isactive,
    coalesce(trim(employeename), 'unknown') as employeename,
    try_to_date(createddate, 'dd-mm-yyyy hh24:mi') as craeteddate

    from {{ source('tdsg_source', 'employees') }}
