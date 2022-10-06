# This extracts all the changed models to run specifically on dev profiles
function dbt_run_changed() {
    children=$1
    models=$(git diff HEAD..HEAD^ --name-only | grep '\.sql$' | awk -F '/' '{ print $NF }' | sed "s/\.sql$/${children}/g" | tr '\n' ' ')
    echo "Running models: ${models}"
    dbt run --models $models --profiles-dir=ci_profiles --target=test
}

dbt_run_changed +