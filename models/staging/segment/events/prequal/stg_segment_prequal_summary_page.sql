-- pull in our event specific columns

{{ segment_event_model(
    source('segment', 'prequal_summary_page'),
    id_column='event_id'
) }}
