{% macro Standardize_gender(column) %}

    {% if column == 'gender' %}
     case

         when upper({{ column }}) = 'MALE' then 'M'
         when upper({{ column }}) = 'M' then 'M'
         when upper({{ column }}) = 'FEMALE' then 'F'
         when upper({{ column }}) = 'F' then 'F'
         else 'unknown'
    end
{% else %}
        {{ column }}
    {% endif %}
   
    
{% endmacro %}
