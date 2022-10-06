with deduplicate as (

      select
          *,
          row_number() over (partition by id order by
              received_at desc) as dedupe
      from {{ source('segment', 'pos_purchase_stage_entered') }}

  )

  select * except (dedupe) from deduplicate
  where dedupe = 1
