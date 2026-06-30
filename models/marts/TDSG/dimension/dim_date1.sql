{{ config(materialized='table') }}

WITH date_spine AS (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('2022-01-01' as date)",
        end_date="cast('2031-01-01' as date)"
    ) }}
),

holidays AS (
    SELECT DISTINCT HolidayDate FROM {{ ref('stg_holidaycalendar') }}
),

final AS (
    SELECT
        CAST(TO_CHAR(date_spine.date_day, 'YYYYMMDD') AS INT)  AS DateKey,
        date_spine.date_day                                     AS FullDate,
        YEAR(date_spine.date_day)                               AS Year,
        MONTH(date_spine.date_day)                              AS Month,
        TO_CHAR(date_spine.date_day, 'MMMM')                    AS MonthName,
        'Q' || CAST(CEIL(MONTH(date_spine.date_day) / 3.0) AS VARCHAR) AS Quarter,
        WEEKOFYEAR(date_spine.date_day)                         AS WeekNumber,
        CASE
            WHEN DAYOFWEEK(date_spine.date_day) IN (0, 6) THEN 'Y'
            ELSE 'N'
        END                                                      AS IsWeekend,
        CASE
            WHEN holidays.HolidayDate IS NOT NULL THEN 'Y'
            ELSE 'N'
        END                                                      AS IsHoliday
    FROM date_spine
    LEFT JOIN holidays
        ON date_spine.date_day = holidays.HolidayDate
),

with_working_day AS (
    SELECT
        *,
        CASE
            WHEN IsWeekend = 'N' AND IsHoliday = 'N' THEN 'Y'
            ELSE 'N'
        END AS IsWorkingDay,
        {{ audit_columns('Generated') }}
    FROM final
)

SELECT * FROM with_working_day