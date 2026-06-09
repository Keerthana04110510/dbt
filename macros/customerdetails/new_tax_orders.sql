{% macro new_tax(column_name,num)%}

{{column_name}}*{{num}}

{% endmacro %}