with source as (

  select * from {{ ref('segment_unioned_deduped_pages') }}

),

renamed as (

    select

        --ids
        nullif(id, '') as page_view_id,
        nullif(anonymous_id, '') as anonymous_id,
        nullif(user_id, '') as user_id,

        nullif(context_ip, '') as ip,
        nullif(context_library_name, '') as library_name,
        nullif(context_library_version, '') as library_version,
        nullif(context_page_path, '') as page_path,
        nullif(context_page_referrer, '') as page_referrer,
        nullif(context_user_agent, '') as user_agent,
        nullif(path, '') as page_url_path,
        nullif(referrer, '') as referrer,
        {{ dbt_utils.get_url_host(field='referrer') }} as referrer_host,
        nullif(title, '') as page_title,
        nullif(url, '') as page_url,
        {{ dbt_utils.get_url_host(field='url') }} as page_url_host,
        nullif(context_page_search, '') as page_search,
        nullif(search, '') as page_url_query,
        lower(nullif(context_campaign_source, '')) as utm_source,
        lower(nullif(context_campaign_medium, '')) as utm_medium,
        lower(nullif(context_campaign_name, '')) as utm_campaign,
        lower(nullif(context_campaign_term, '')) as utm_term,
        lower(nullif(context_campaign_content, '')) as utm_content,
        split(url, 'gclid=')[safe_ordinal(2)] as gclid,

        --dates
        loaded_at,
        original_timestamp as event_timestamp,
        received_at as received_at_tstamp,
        sent_at as sent_at_tstamp,
        timestamp as tstamp,
        uuid_ts as uuid_ts

    from source

),

# add necessary fields to use attributed_channel macro at the session level
# traffic_category at this level only looks at one set of Segment UTM data,
# and is not as accurate as attributed_channel at the fct_attribution level.
temporary_fields as (

    select
        *,
        cast(null as string) as lead_source,
        cast(null as string) as type_of_sem
    from renamed

),

{{ lead_source_compute('temporary_fields') }}

# de-duping has already happened in our modified source table
# remove temporary fields
select
    * except (channel, lead_source, lead_source_computed, type_of_sem),
    channel as traffic_category
from attribution_channel
