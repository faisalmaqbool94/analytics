with source as (

    select * from {{ source('adwords_old', 'campaigns') }}

),

renamed as (

    select

        --ids
        id as campaign_id,

        --fields
        nullif(name,'') as campaign_name,
        nullif(status,'') as status,

        --dates
        -- We are not converting dates to EST, as they are defaulted to midnight
        -- and are already accurate. Converting would move dates back one day.
        date(startdate) as date_day,
        {{ timestamp_convert('_sdc_received_at') }} as received_at,

        row_number() over (partition by id order by _sdc_received_at desc) as row_num
    from source

)

select * except (row_num) from renamed
where row_num = 1
