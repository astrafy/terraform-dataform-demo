resource "google_bigquery_dataset" "bq_datasets" {
  for_each      = toset(var.bq_datasets)
  dataset_id    = each.value
  friendly_name = each.value
  location      = "EU"
  project       = module.project.project_id
}
