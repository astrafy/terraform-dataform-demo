# resource "google_dataform_repository_release_config" "dev_release" {
#   provider = google-beta

#   project    = google_dataform_repository.dataform_repository.project
#   region     = google_dataform_repository.dataform_repository.region
#   repository = google_dataform_repository.dataform_repository.name

#   name          = "dev_release"
#   git_commitish = "dev"
#   cron_schedule = "0 7 * * *"
#   time_zone     = "Europe/Paris"

#   code_compilation_config {
#     default_database = module.project_dev.project_id
#     assertion_schema = "bqdts_finops_tests"
#     # default_schema   = "example-dataset"
#     # default_location = "EU"
#     # database_suffix  = ""
#     # schema_suffix    = ""
#     # table_prefix     = ""
#     # vars = {
#     #   var1 = "value"
#     # }
#   }
# }

# resource "google_dataform_repository_workflow_config" "dev_workflow" {
#   provider = google-beta

#   project        = google_dataform_repository.dataform_repository.project
#   region         = google_dataform_repository.dataform_repository.region
#   repository     = google_dataform_repository.dataform_repository.name
#   release_config = google_dataform_repository_release_config.dev_release.id

#   name          = "dev_workflow"
#   cron_schedule = "0 8 * * *"
#   time_zone     = "Europe/Paris"

#   invocation_config {
#     # included_tags                            = ["tag_1"]
#     transitive_dependencies_included         = true
#     transitive_dependents_included           = true
#     fully_refresh_incremental_tables_enabled = false
#     service_account                          = google_service_account.dataform_dev_runner.email
#   }
# }
