module "project_ops_demo" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "14.4.0"
  name                    = "mydemo-dataform-ops"
  org_id                  = var.organization_id
  random_project_id       = true
  default_service_account = "delete"
  auto_create_network     = false
  folder_id               = google_folder.dataform-demo.folder_id
  billing_account         = var.billing_account_id
  activate_apis = [
    "compute.googleapis.com", "bigquery.googleapis.com", "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com", "bigquerydatatransfer.googleapis.com", "pubsub.googleapis.com",
    "logging.googleapis.com", "iap.googleapis.com", "cloudasset.googleapis.com", "dataform.googleapis.com",
    "secretmanager.googleapis.com", "workflows.googleapis.com"
  ]
  labels = {}
}
