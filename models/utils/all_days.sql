{{
    config(
        materialized='table'
    )
}}

with leads as (

  select created_date from {{ref('some_source')}}

),

base as (

    select
        min(created_date) over () as dates,
        row_number() over () as numbered
    from leads

),

final as (

    select
        date_add(DATE(dates), interval (numbered - 1) day) as date_day
    from base

)

select * from final
where date_day <= date_add(current_date, interval 1 day)
order by date_day
