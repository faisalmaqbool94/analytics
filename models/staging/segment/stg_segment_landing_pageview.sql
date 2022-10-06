with source as (

    select * from {{ ref('stg_segment_pages') }}

),

filtered as (

    select
        *
    from source
    where page_url_path = '/'

)

select * from filtered
