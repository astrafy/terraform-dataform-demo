variable "billing_account_id" {
  description = "Billing account to use for projects"
  type        = string
}

variable "organization_id" {
  description = "Organization ID"
  type        = number
}

variable "demos_folder" {
  description = "Folder for demo projects"
  type        = string
}

variable "dataform_demo_gitlab_token" {
  type        = string
  description = "gitlab token for dataform demo"
}
