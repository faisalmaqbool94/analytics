{{ segment_event_model(
    source('segment', 'get_estimate'),
    id_column='get_estimate_id',
    additional_event_columns='
      context_campaign_keyword,
      cta,
      location'
) }}
