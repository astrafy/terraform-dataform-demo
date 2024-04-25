resource "google_service_account" "dataform_runner" {
  account_id   = "dataform-${var.env}-runner"
  display_name = "Dataform ${var.env} runner"
  project      = module.project.project_id
  description  = "Default account which Dataform pipelines will run with"
}

resource "google_service_account" "workflow_dataform" {
  project      = module.project.project_id
  account_id   = "${var.env}-dataform-workflow-runner"
  display_name = "${var.env} Dataform Workflow Runner"
  description  = "Runs dataform workflows in ${var.env}"
}
