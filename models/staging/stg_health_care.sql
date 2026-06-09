{{  config(materialized='view') }}

SELECT * FROM {{ source('stage', 'seed_health_care') }}