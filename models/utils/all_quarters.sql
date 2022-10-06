{{
    config(
        materialized='table'
    )
}}

select
  date_trunc(date_day, quarter) as date_quarter
from {{ ref('all_days') }}
group by date_quarter
order by date_quarter
