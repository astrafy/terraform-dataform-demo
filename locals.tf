locals {
  bq_datasets = toset(["bqdts_finops_lz", "bqdts_finops_stg", "bqdts_finops_int", "bqdts_finops_dm", "bqdts_finops_tests"])
}
