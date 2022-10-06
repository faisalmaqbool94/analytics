-- pull in our event specific columns
{{ segment_event_model(
    source('segment', 'renovation_loan_calculator_updated'),
    id_column='calculator_id',
    additional_event_columns="
        context_campaign_keyword,
        current_home_value,
        current_mortgage_balance,
        future_home_value,
        renovation_cost"
) }}
