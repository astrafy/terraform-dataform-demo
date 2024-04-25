resource "google_dataform_repository" "dataform_repository" {
  provider = google-beta

  name         = "dataform_demo"
  display_name = "dataform_demo"

  project = module.project.project_id
  region  = "europe-west1"

  service_account = google_service_account.dataform_runner.email
  git_remote_settings {
    url                                 = "https://gitlab.com/demos2261901/dataform-demo.git"
    default_branch                      = "main"
    authentication_token_secret_version = var.gitlab_secret.id
  }

  workspace_compilation_overrides {
    default_database = module.project.project_id
    # schema_suffix    = "_suffix"
    # table_prefix     = "prefix_"
  }
}
