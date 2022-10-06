with source as (

  select * from {{ref('stg_funnel_get_estimate_cta')}}

),

fill_in_cta as (

  select

    source.* except (cta),
    case
      when cta is not null then cta
      -- prior to the launch of the new site
      when cta is null and created_at < '2019-09-16' then 'Get Rate Estimate'
      -- from the launch of the new site until we start capturing cta text
      when cta is null and created_at >= '2019-09-16' and created_at < '2019-09-28' then 'Get Free Quote'
    end as cta

  from source

)

select * from fill_in_cta
