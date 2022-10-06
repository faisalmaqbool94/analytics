with funnel as (
    select distinct
    lower(email) as email,
    original_timestamp,
    'pos' as funnel_type
    from {{ ref('stg_segment_pos_lead_created') }}
    where email is not null

    union all

    select distinct
    lower(email) as email,
    original_timestamp,
    'calculator' as funnel_type
    from {{ ref('stg_segment_calculator_lead_created') }}
    where email is not null

    union all

    select distinct
    lower(email) as email,
    original_timestamp,
    'prequal' as funnel_type
    from {{ ref('stg_segment_prequal_lead_created') }}
    where email is not null

    union all

    select distinct
    lower(email) as email,
    original_timestamp,
    'estimate' as funnel_type
    from {{ ref('stg_segment_funnel_lead_created') }}
    where email is not null
),

deduplication as (
    select
    *,
    row_number() over (partition by email order by original_timestamp desc) as dedupe
    from funnel
)

select * except(dedupe)
from deduplication
where dedupe = 1
