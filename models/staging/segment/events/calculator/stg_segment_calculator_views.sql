-- pull in our event specific columns

{{ segment_event_model(
    source('segment', 'calculator_calculator_page'),
    id_column='event_id'
) }}
