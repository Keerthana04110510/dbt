{% macro clean_string(column, allowed_values=[]) %}
    case
        when {{ column }} is null then null
        {% if allowed_values | length > 0 %}
            when lower(trim({{ column }})) in (
                {%- for val in allowed_values -%}
                    '{{ val | lower }}'{% if not loop.last %}, {% endif %}
                {%- endfor -%}
            )
            then lower(trim({{ column }}))
            else 'other'
        {% else %}
            lower(trim({{ column }}))
        {% endif %}
    end
{% endmacro %}
