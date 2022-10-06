with source as (

    select * from {{ ref('segment_unioned_deduped_identifies') }}

),

renamed as (

    select

        --ids
        nullif(id, '') as identifies_id,
        nullif(anonymous_id, '') as anonymous_id,
        nullif(user_id, '') as user_id,

        --data
        nullif(lower(email), '') as email,
        nullif(context_ip, '') as ip,
        nullif(first_name, '') as first_name,
        nullif(last_name, '') as last_name,
        nullif(context_library_name, '') as library_name,
        nullif(context_library_version, '') as library_version,
        nullif(context_page_path, '') as page_path,
        nullif(context_page_referrer, '') as page_referrer,
        nullif(context_user_agent, '') as user_agent,
        nullif(context_page_search, '') as page_search,
        nullif(context_page_url, '') as page_url,
        nullif(context_page_title, '') as page_title,

        --dates
        loaded_at,
        timestamp(created_at) as created_at,
        original_timestamp,
        received_at,
        sent_at,
        timestamp,
        uuid_ts

    from source

)


# de-duping has already happened in our modified source table

select *
from renamed
