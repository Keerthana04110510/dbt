{{   config(materialized="view")  }}

{% set valid_types = var('accepted_txn_type') %}
select * from {{ ref('stg_transactions') }}

where txn_type in (
    {% for val in valid_types %}
        '{{ val }}'{% if not loop.last %}, {% endif %}
    {% endfor %}
)

{% if not var('include_pending', false) %}
    and txn_status != 'pending'
{% endif %}