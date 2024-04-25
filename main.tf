module "dataform_dev" {
  source = "./dataform"

  organization_id    = var.organization_id
  billing_account_id = var.billing_account_id
  dataform_folder    = google_folder.dataform-demo.name
  bq_datasets        = local.bq_datasets
  ops_project_id     = module.project_ops_demo.project_id
  gitlab_secret      = google_secret_manager_secret_version.gitlab_token
  env                = "dev"
}

module "dataform_prd" {
  source = "./dataform"

  organization_id    = var.organization_id
  billing_account_id = var.billing_account_id
  dataform_folder    = google_folder.dataform-demo.name
  bq_datasets        = local.bq_datasets
  ops_project_id     = module.project_ops_demo.project_id
  gitlab_secret      = google_secret_manager_secret_version.gitlab_token
  env                = "prd"
}
