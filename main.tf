module "infra_tables" {
  source = "./infra/tables"
}

module "infra_jobs" {
  source = "./infra/jobs"
}

module "infra_buckets" {
  source = "./infra"
}
