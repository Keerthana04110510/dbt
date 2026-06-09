{% macro date_bucket(ts, level) %}
    {% if level == 'month' %}
        date_trunc('month', {{ ts }})
    {% elif level == 'day' %}
        {{ ts }}
    {% else %}
        {{ ts }}
    {% endif %}
{% endmacro %}