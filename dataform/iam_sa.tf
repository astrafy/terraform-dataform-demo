# Default dataform SA
resource "google_secret_manager_secret_iam_member" "dataform_sa_secret_accessor" {
  secret_id = var.gitlab_secret.secret
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${module.project.project_number}@gcp-sa-dataform.iam.gserviceaccount.com"
}

resource "google_service_account_iam_member" "dataform_sa_tc" {
  service_account_id = google_service_account.dataform_runner.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:service-${module.project.project_number}@gcp-sa-dataform.iam.gserviceaccount.com"
}

# Dataform runner
resource "google_project_iam_member" "bq_jobuser_df_runner" {
  project = module.project.project_id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.dataform_runner.member
}

resource "google_project_iam_member" "bq_data_editor_df_runner" {
  project = module.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = google_service_account.dataform_runner.member
}

# Workflow runner
resource "google_project_iam_member" "workflow_invoker" {
  project = module.project.project_id
  role    = "roles/workflows.invoker"
  member  = google_service_account.workflow_dataform.member
}

resource "google_service_account_iam_member" "workflow_sa_tc" {
  service_account_id = google_service_account.dataform_runner.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = google_service_account.workflow_dataform.member
}

resource "google_project_iam_member" "df_editor_workflow" {
  project = module.project.project_id
  role    = "roles/dataform.editor"
  member  = google_service_account.workflow_dataform.member
}
