{% macro get_fiscal_quarter(date_col) %}

case when month{{column}} <4
     then 'Q1'
     when month{{column}} between 4 and 7
     then 'Q2'
     when month{{column}} between 7 and 10
     then 'Q3'
     else 'Q4'
 end 
    
{% endmacro %}