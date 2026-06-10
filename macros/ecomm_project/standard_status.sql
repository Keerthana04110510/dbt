{% macro standardize_status(column_name) %}

    CASE 
        WHEN UPPER({{ column_name }}) = 'ACTIVE' THEN UPPER({{ column_name }})
        ELSE 'UNKNOWN'
    END

{% endmacro %}