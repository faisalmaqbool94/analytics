-- With this model, we bring together two separate Segment sources - com and the estimate app

{{ dbt_utils.union_relations(
    relations=[ref('base_segment_renofi_com_identifies'), ref('base_segment_estimate_identifies')]
) }}
