{% macro my_cal(number1,number2)  %}

(coalesce({{ number1}},0) * coalesce({{number2}},0))

{% endmacro %}