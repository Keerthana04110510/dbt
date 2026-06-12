{% macro standardize_status(column) %}

 
 case 
     when upper({{ column }}) = 'active'
     then 'ACTIVE'
     when upper({{ column }}) = 'ACTIVE'
     then 'ACTIVE'
     when upper({{ column }}) = 'Active'
     then 'ACTIVE'
     else
     'unknown'
end




{% endmacro %}