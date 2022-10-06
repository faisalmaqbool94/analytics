with unioned as (

    select * from {{ ref('base_segment_unioned_pages') }}

),

deduplicate as (

    select
        *,
        row_number() over (partition by id order by
            received_at desc) as dedupe
    from unioned

)

select
    * except (dedupe, loaded_at, original_timestamp, received_at, sent_at, timestamp, uuid_ts),

    {{ timestamp_convert('loaded_at') }} as loaded_at,
    {{ timestamp_convert('original_timestamp') }} as original_timestamp,
    {{ timestamp_convert('received_at') }} as received_at,
    {{ timestamp_convert('sent_at') }} as sent_at,
    {{ timestamp_convert('timestamp') }} as timestamp,
    {{ timestamp_convert('uuid_ts') }} as uuid_ts

from deduplicate
where
    dedupe = 1
    {% if not should_use_full_dataset() %} and
    date(original_timestamp) >= date_sub(current_date(), interval 3 month)
    {% endif %}
