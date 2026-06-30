
{% macro audit_columns(source_system) %}
    '{{ source_system }}'::VARCHAR(50)     AS dw_source_system,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ     AS dw_inserted_date,
    CURRENT_TIMESTAMP()::TIMESTAMP_NTZ     AS dw_updated_date,
    '{{ var("batch_id", run_started_at.strftime('%Y%m%d%H%M%S')) }}'::VARCHAR(30) AS dw_batch_id,
    'Y'::CHAR(1)                           AS dw_is_active
{% endmacro %}

{% macro date_to_key(date_column) %}
    CAST(TO_CHAR({{ date_column }}, 'YYYYMMDD') AS INT)
{% endmacro %}

{% macro tat_bucket(tat_days_column) %}
    CASE
        WHEN {{ tat_days_column }} IS NULL         THEN 'No PO Yet'
        WHEN {{ tat_days_column }} < 5              THEN 'Less than 5'
        WHEN {{ tat_days_column }} BETWEEN 5 AND 7  THEN '5 to 7'
        ELSE                                              'More than 7'
    END
{% endmacro %}

{% macro is_on_time(grn_date_col, delivery_date_col) %}
    CASE
        WHEN {{ grn_date_col }} IS NULL OR {{ delivery_date_col }} IS NULL THEN 'N'
        WHEN {{ grn_date_col }} <= {{ delivery_date_col }}                 THEN 'Y'
        ELSE 'N'
    END
{% endmacro %}

{% macro scd2_columns() %}
    CURRENT_DATE()::DATE  AS effective_from,
    NULL::DATE            AS effective_to,
    'Y'::CHAR(1)          AS is_current
{% endmacro %}
