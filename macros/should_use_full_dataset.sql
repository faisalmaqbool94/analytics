{#
This macro can be used to conditionally filter data in a model to a limited dataset for speed.
The macro returns true if the target is one of those specified in full_dataset_target_names in dbt_project.yml,
or the `should_use_full_dataset` boolean variable is specified with
e.g. dbt build --vars '{"should_use_full_dataset": "t"}'
(any truthy value works)

Example:

select * from table
{% if not should_use_full_dataset() %}
where date(created_at) >=  date_sub(current_date(), interval 3 month)
{% endif %}

#}

{% macro should_use_full_dataset() %}

    {{ return(var('should_use_full_dataset', target.name in var('full_dataset_target_names'))) }}

{% endmacro %}
