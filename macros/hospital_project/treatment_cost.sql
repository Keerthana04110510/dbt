{% macro treatment_cost(column) %}

{% if column == 'treatment_cost' %}
      case 
          when {{ column }} >5000 then 'Expensive'
          when {{ column }} between 3000 and 5000 then 'Moderate'
          else 'low cost'
       end
{% else %}
    {{ column }}
    
{% endif %}
    
{% endmacro %}