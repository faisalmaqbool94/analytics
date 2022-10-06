{{ config(materialized='table') }}

with performance as (

  select * from {{ ref('base_adwords_campaign_performance') }}

),

campaigns as (

  select * from {{ ref('stg_adwords_campaigns') }}

),

joined as (

  select
    performance.*,
    campaigns.campaign_name
  from performance
  left join campaigns using (campaign_id)

)

select *
from joined
{% if not should_use_full_dataset() %}
where date_day >=  date_sub(current_date(), interval 3 month)
{% endif %}
