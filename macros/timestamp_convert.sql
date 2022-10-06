--this macro allows you to feed in a timestamp field and return it in EST
--the timestamp will still display the timezone as 'UTC' in BigQuery, however.

{% macro timestamp_convert(column) %}

  {{dbt_date.convert_timezone(column, 'America/New_York') }}

{% endmacro %}
