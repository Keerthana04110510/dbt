{% macro doctor_salary(column) %}

{% if column == 'salary' %}
     case 
        when {{ column }} > 150000 then 'High Salary'
        when {{ column }} between  150000  and 100000 then 'Medium salary'
        else 'low salary'
    end
{% else %}
    {{ column }} 
{% endif %}
    
{% endmacro %}