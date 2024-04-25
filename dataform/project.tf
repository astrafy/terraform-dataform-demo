module "project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "14.4.0"
  name                    = "mydemo-dataform-${var.env}"
  org_id                  = var.organization_id
  random_project_id       = true
  default_service_account = "delete"
  auto_create_network     = false
  folder_id               = var.dataform_folder
  billing_account         = var.billing_account_id
  activate_apis = [
    "compute.googleapis.com", "bigquery.googleapis.com", "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com", "bigquerydatatransfer.googleapis.com", "pubsub.googleapis.com",
    "logging.googleapis.com", "iap.googleapis.com", "cloudasset.googleapis.com", "dataform.googleapis.com",
    "workflows.googleapis.com", "eventarc.googleapis.com", "cloudscheduler.googleapis.com"
  ]
  labels = {
    "env" = var.env
  }
}
