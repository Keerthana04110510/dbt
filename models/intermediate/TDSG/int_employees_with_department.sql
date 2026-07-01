{{ config(materialized='view') }}
WITH employees AS (
    SELECT * FROM {{ ref('stg_employees') }}
),
department AS (
    SELECT * FROM {{ ref('stg_department') }}
),
joined AS (
    SELECT
        e.EmployeeKey,
        e.DepartmentKey,
        e.ReportingManagerKey,
        e.EmployeeCode,
        e.EmployeeName,
        e.EmpDesignation,
        e.Email,
        e.IsActive,
        d.DepartmentName,
        d.DivisionKey
    FROM employees e
    LEFT JOIN department d
        ON e.DepartmentKey = d.DepartmentKey
)

SELECT * FROM joined