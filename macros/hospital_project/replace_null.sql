{% macro replace_null(column) %}

{% if column == 'insurance_type' %}
      case 
      when upper({{ column }})= upper({{ column }})
      then {{ column }}
      else 'unknown'
      end 
{% else %}
     {{ column }}
{% endif %}  
    
{% endmacro %}