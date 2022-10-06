-- Test to ensure all leads are bucketed with tag to run separately for data quality
{{ config(severity='error', tags = ['business-oriented']) }}

## Lead bucketing logic should account for all leads - if it does not,
## we should dig in and add more buckets:

with lead_buckets as (

    select
        lead_id,
        lead_bucket
    from {{ ref('our business source') }}
    where lead_id is not null

),

validation as (

    select lead_id
    from lead_buckets
    where lead_bucket is null

)

select *
from validation