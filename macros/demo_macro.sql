{% macro clean_null(column, default_value='Unknown') %}
    

    case 
       when {{coulmn}} is null 
       then 'null'
       when {{ column}} is 'N/A'
       then 'null'
       else {{column_name}}
       end

{% endmacro %}
     
{% macro clean_null(column, default_value='Unknown') %}
    {% if column is null %}
      'Null'
    {% elif column is N/A  %}
      'Null'
    {% else %}
       {{ column_name }}

    {% endif %}
    {% endmacro %}