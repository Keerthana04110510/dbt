{% snapshot snap_employee %}
{{
    config(
        target_database='DBT_TRAINING',
        target_schema='DBT_KEERTHANA',
        unique_key='EmployeeKey',
        strategy='check',
        check_cols=[
            'DepartmentKey',
            'ReportingManagerKey',
            'EmployeeCode',
            'EmployeeName',
            'EmpDesignation',
            'Email',
            'IsActive'
        ],
        invalidate_hard_deletes=True
    )
}}
SELECT
    EmployeeKey,
    DepartmentKey,
    ReportingManagerKey,
    EmployeeCode,
    TRIM(EmployeeName) AS EmployeeName,
    EmpDesignation,
    Email,
    IsActive
FROM {{ ref('stg_employees') }}
{% endsnapshot %}