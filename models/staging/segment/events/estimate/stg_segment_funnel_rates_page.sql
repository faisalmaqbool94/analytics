-- pull in our event specific columns

{{ segment_event_model(
    source('segment', 'funnel_rates_page'),
    id_column='event_id'
) }}
