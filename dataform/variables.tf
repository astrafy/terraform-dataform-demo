variable "env" {
  description = "Environment"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account to use for projects"
  type        = string
}

variable "organization_id" {
  description = "Organization ID"
  type        = number
}

variable "dataform_folder" {
  description = "Folder for dataform demo"
  type        = string
}

variable "bq_datasets" {
  description = "BigQuery datasets"
  type        = list(string)
}

variable "ops_project_id" {
  description = "Project ID of the operation project"
  type        = string
}

variable "gitlab_secret" {
  description = "gitlab secret id"
}
