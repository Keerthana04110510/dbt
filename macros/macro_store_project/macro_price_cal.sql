{% macro calculate_net_sales(price, quantity, discount_pct )%}


{{ price}}  * {{ quantity }} -
(({{ price}}  * {{ quantity }}) * {{ discount_pct }}/100)
    
{% endmacro %}