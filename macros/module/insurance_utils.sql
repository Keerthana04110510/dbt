{% macro classify_risk(credit_score, risk_tier) %}

{ {% if risk_tier=='high' %}

   case  when credit_score < 580 
         then 'critical'
         when credit_score between 580 and 649
         then 'high'
         when credit_score between 650 and 719
         then 'moderate'
         else 'low'

    
{% endif %}
    
{% endmacro %}