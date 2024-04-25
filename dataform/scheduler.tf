resource "google_cloud_scheduler_job" "daily_dataform" {
  project          = module.project.project_id
  name             = "daily_dataform"
  region           = "europe-west1"
  description      = "Gets today's date and trigger dataform daily workflow"
  schedule         = "0 8 * * *"
  time_zone        = "Europe/Paris"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://workflowexecutions.googleapis.com/v1/${google_workflows_workflow.dataform.id}/executions"
    body = base64encode(
      jsonencode({
        "argument" : jsonencode({}),
        "callLogLevel" : "CALL_LOG_LEVEL_UNSPECIFIED"
        }
    ))

    oauth_token {
      service_account_email = google_service_account.workflow_dataform.email
      scope                 = "https://www.googleapis.com/auth/cloud-platform"
    }
  }

}
