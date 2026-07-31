{{ config(
    materialized = 'incremental',
    unique_key   = 'employee_sk',
    incremental_strategy = 'merge'
) }}

WITH source AS (
    SELECT * FROM {{ ref('int_employees_with_department') }}
),

current_data AS (
    SELECT
        EmployeeKey,
        DepartmentKey,
        ReportingManagerKey,
        EmployeeCode,
        EmployeeName,
        EmpDesignation,
        Email,
        IsActive,
        DepartmentName,
        DivisionKey,
        {{ dbt_utils.generate_surrogate_key([
            'EmployeeKey', 'DepartmentKey', 'EmpDesignation'
        ]) }} AS employee_sk
    FROM source
)

{% if is_incremental() %}

SELECT
    employee_sk,
    EmployeeKey,
    DepartmentKey,
    ReportingManagerKey,
    EmployeeCode,
    EmployeeName,
    EmpDesignation,
    Email,
    IsActive,
    DepartmentName,
    DivisionKey,
    {{ scd2_columns() }},
    {{ audit_columns('HR_SYSTEM') }}
FROM current_data
WHERE employee_sk NOT IN (SELECT employee_sk FROM {{ this }})

{% else %}

SELECT
    employee_sk,
    EmployeeKey,
    DepartmentKey,
    ReportingManagerKey,
    EmployeeCode,
    EmployeeName,
    EmpDesignation,
    Email,
    IsActive,
    DepartmentName,
    DivisionKey,
    {{ scd2_columns() }},
    {{ audit_columns('HR_SYSTEM') }}
FROM current_data

{% endif %}

