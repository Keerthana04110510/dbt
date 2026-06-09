{% macro replace_values(column_name, unknown)%}

coalesce({{column_name}},'{{unknown}}')

{%endmacro%}