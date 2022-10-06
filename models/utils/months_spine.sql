{{
    config(
        materialized='table'
    )
}}

with months as (

  {{ dbt_utils.date_spine(
      datepart="month",
      start_date="date(2018, 06, 01)",
      end_date="date_add(current_date(), interval 1 year)"
     )
  }}

)

select
  date_trunc(date(date_month), month) as date_month
from months
group by date_month
order by date_month
