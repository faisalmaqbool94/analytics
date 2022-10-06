with source as (

    select
        * except (utm_source, utm_medium, utm_campaign, utm_term, utm_content, referrer, referrer_host, first_page_url),
        lower(utm_source) as utm_source,
        lower(utm_medium) as utm_medium,
        lower(utm_campaign) as utm_campaign,
        lower(utm_term) as utm_term,
        lower(utm_content) as utm_content,
        lower(referrer) as referrer,
        lower(referrer_host) as referrer_host,
        lower(first_page_url) as first_page_url,
    from {{ ref('segment_web_sessions') }}
    {% if not should_use_full_dataset() %}
    where date(session_start_tstamp) >= date_sub(current_date(), interval 3 month)
    {% endif %}
),

ips as (

    select
        session_id,
        ip,
        user_agent
    from {{ ref('segment', 'segment_web_page_views__sessionized') }}

),

joined as (

    select
        source.*,
        ips.ip
    from source
    left join ips on source.session_id = ips.session_id

),

calculate as (

    select
        *,
        case
            when page_views = 1 then true
            else false
        end as user_bounced
    from joined

),

filtered as (

    select *
    from calculate
    where ip not in (select bot_ip_address from {{ ref('bots') }})

),

# add necessary fields to use attributed_channel macro at the session level
# traffic_category at this level only looks at one set of Segment UTM data,
# and is not as accurate as attributed_channel at the fct_attribution level.
temporary_fields as (

    select
        *,
        cast(null as string) as lead_source,
        cast(null as string) as type_of_sem
    from filtered

),

{{ lead_source_compute('temporary_fields') }},

deduplicate as (

    select
        # remove temporary fields
        * except (channel, lead_source, lead_source_computed, type_of_sem),
        channel as traffic_category,
        row_number() over (partition by session_id order by
            session_end_tstamp desc) as dedupe
    from attribution_channel

)

select * except (dedupe) from deduplicate
where dedupe = 1
