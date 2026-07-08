    {{ config(materialized='table') }}

    WITH source AS (
        SELECT * FROM {{ ref('stg_department') }}
    ),
    final AS (
        SELECT
            DepartmentKey,
            DivisionKey,
            DepartmentName,
            DepartmentHead,
            CreatedDate,
            UPPER(
                REGEXP_REPLACE(
                    REGEXP_REPLACE(DepartmentName, '[^A-Za-z ]', ''),  
                    '([A-Za-z])[A-Za-z]*\\s*', '\\1'                   
                )
            ) AS DepartmentCode,
            ActiveFlag,
            {{ audit_columns('HR_SYSTEM') }}
        FROM source
    )
    SELECT * FROM final