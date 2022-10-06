{{
    config(
        materialized='table'
    )
}}

with quarters as (

  {{ dbt_utils.date_spine(
      datepart="quarter",
      start_date="date(2018, 06, 01)", -- some date
      end_date="date_add(current_date(), interval 1 year)"
     )
  }}

)

select
  date_trunc(date(date_quarter), quarter) as date_quarter
from quarters
group by date_quarter
order by date_quarter
