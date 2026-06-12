{% macro generate_surrogate_key(column) %}

{{ dbt_utils.generate_surrogate_key(column) }} 
    
{% endmacro %}