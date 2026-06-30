{{
    config(
        materialized='table'
    )
}}

SELECT
    PurchasingGroupKey,
    GroupCode,
    GroupName,
    PurchaserName,
    PurchaserID,
    Division,
    FromDate,
    ToDate,
    IsActive,
    ActiveFlag,
    dbt_valid_from AS EffectiveFrom,
    dbt_valid_to AS EffectiveTo,
    CASE
        WHEN dbt_valid_to IS NULL
        THEN 'Y'
        ELSE 'N'
    END AS IsCurrent
