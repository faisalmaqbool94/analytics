-- this macro dedup the source (can be used for models based on stitch sources) based on the partition key and order
-- includes the where as well in case we need dedup on specific condition
/*
    arguments:
        model: direct reference to a model or a cte
        key: parition by key
        order_by: ordering column
        order: for ordering sequence [ascending or decending]
        filter_key: to filter on a column, like status or stage
        filter_value: filtering value to be checed
            accepted_values: ['is null', 'not null', 'any_value_to_be_equal_to']
        from_cte: you want to dedup, get first/last tuple by directly referring to a model or from cte. defualt: false (referring to a model/node)
*/
{%- macro dedup_source(model, key, order_by, order, from_cte = false, filter_key = None, filter_value = None) -%}
  select deduped.* except(rn)
    from (
      select
        _inner.*,
        row_number() over (partition by {{ key }} order by {{ order_by }} {{ order }} ) as rn

    {% if from_cte %}
    from {{ model }} as _inner
    {% else %}
    from {{ ref(model) }} as _inner
    {% endif %}

    {% if filter_key is not none and filter_value is not none %}
        {% if filter_value == 'is null' %}
            where {{ filter_key }} is null
        {% elif filter_value == 'not null' %}
            where {{ filter_key }} is not null
        {% else %}
            where {{ filter_key }} = '{{ filter_value }}'
        {% endif %}
    {% endif %}

    ) as deduped
  where deduped.rn = 1
{%- endmacro -%}
