{{
    config(
        materialized="incremental", 
        unique_key="txn_id", 
        incremental_strategy="merge"
    )
}}

with source_data as (select
            md5(t.txn_id) as txn_sk,
            t.txn_id,
            t.account_number,
            a.account_sk,
            t.txn_date,
            t.txn_status,
            t.amount,
            t.txn_type,
            t.updated_at
        from {{ ref("stg_transactions") }} t
        left join {{ ref("dim_account") }} a 
        on t.account_number = a.account_sk
    ),
    final as ( select s.*,
            {% if is_incremental() %}
                case
                    when t.txn_id is null then current_timestamp 
                else t.created_at
                end as created_at,
            {% else %} current_timestamp as created_at,
            {% endif %}
            current_timestamp as audit_updated_at
        from source_data s

        {% if is_incremental() %}
            left join {{ this }} t 
            on s.txn_id = t.txn_id
        {% endif %}
    )
select *
from final
{% if is_incremental() %}
    where updated_at > (select coalesce(max(updated_at), '1900-01-01') from {{ this }})
{% endif %}