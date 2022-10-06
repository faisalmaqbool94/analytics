{{
    config(
        materialized='table'
    )
}}

with days as (

  {{ dbt_utils.date_spine(
      datepart="day",
      start_date="date(2018, 01, 01)",
      end_date="date_add(current_date(), interval 1 year)"
     )
  }}

)

select
  date(date_day) as date_day
from days
group by date_day
order by date_day
