with source as (

    select
        *,
        row_number() over (
            partition by
                campaignid,
                day,
                googleclickid
            order by
                _sdc_received_at desc,
                __sdc_primary_key
        ) as row_number
    from {{ source('adwords_old', 'click_performance_report') }}

)

select

    --ids
    {{ dbt_utils.surrogate_key(['campaignid', 'day', 'googleclickid']) }} as id,
    nullif(googleclickid,'') as gcl_id,
    adid as ad_id,
    campaignid as campaign_id,
    adgroupid as ad_group_id,

    --dates
    -- We are not converting dates to EST, as they are defaulted to midnight
    -- and are already accurate. Converting would move dates back one day.
    date(day) as date_day,
    {{ timestamp_convert('_sdc_received_at') }} as received_at,

    --fields
    nullif(clicktype, '') as click_type,
    nullif(device, '') as device

from source
where row_number = 1
