locals {
  users = ["user:alejandro@astrafy.io"]
  roles = [
    "roles/monitoring.admin", "roles/bigquery.admin", "roles/secretmanager.admin", "roles/storage.admin",
    "roles/workflows.admin", "roles/iam.serviceAccountAdmin", "roles/eventarc.admin", "roles/cloudfunctions.admin",
    "roles/cloudscheduler.admin", "roles/logging.admin"
  ]
}

# IAM to access the demo
resource "google_folder_iam_binding" "user_roles" {
  for_each = toset(local.roles)
  folder   = google_folder.dataform-demo.name
  role     = each.value

  members = local.users
}
