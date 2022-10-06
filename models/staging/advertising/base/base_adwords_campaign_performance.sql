with source as (

    select
        *,
        row_number() over (
            partition by
                campaignid
                , day
                , networkwithsearchpartners
            order by
                _sdc_received_at desc
                , __sdc_primary_key
        ) as row_number
    from {{ source('adwords', 'campaign_performance_report') }}

)


select

    --ids
    {{ dbt_utils.surrogate_key(['campaignid', 'day']) }} as id,
    campaignid as campaign_id,

    --dates
    -- We are not converting dates to EST, as they are defaulted to midnight
    -- and are already accurate. Converting would move dates back one day.
    date(day) as date_day,
    max({{ timestamp_convert('_sdc_received_at') }}) as received_at,

    --fields
    sum(clicks) as clicks,
    sum(impressions) as impressions,
    sum(conversions) as conversions,
    sum(cast(cast(cost as numeric)/1000000.00 as numeric)) as spend

from source
where row_number = 1
group by 1, 2, 3
