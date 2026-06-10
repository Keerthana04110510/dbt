{% macro calculate_order_amount(quantity, price) %}

{{ quantity }} * {{ price }}

{% endmacro %}