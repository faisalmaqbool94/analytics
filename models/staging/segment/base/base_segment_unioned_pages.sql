-- With this model, we bring together two separate Segment sources - com and the estimate app
-- By unioning the views and then de-duping based on received_at, we should have a contiguous session

{{ dbt_utils.union_relations(
    relations=[ref('base_segment_renofi_com_pages'), ref('base_segment_estimate_pages')]
) }}
