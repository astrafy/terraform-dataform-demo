resource "google_folder" "dataform-demo" {
  display_name = "dataform-demo"
  parent       = var.demos_folder
}
