select *
from {{ ref('dim_patient') }}
where date_of_admission > current_date()