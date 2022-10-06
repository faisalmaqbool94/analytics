{{
    config(
        materialized='table'
    )
}}

select
  date_trunc(date_day, month) as date_month
from {{ ref('all_days') }}
group by date_month
order by date_month
