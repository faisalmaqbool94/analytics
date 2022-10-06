-- Note Segment recommends querying their views (would be pages_view)
-- Segment's views only make the last 60 days of data available
-- https://segment.com/docs/destinations/bigquery/#schema

select * from {{ source('segment', 'pages') }}
