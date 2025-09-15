resource "aws_glue_job" "job_green_raw_to_bronze" {
  name              = "job_green_raw_to_bronze"
  role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault"
  worker_type       = "G.1X"
  number_of_workers = 5
  timeout           = 10
  execution_class   = "FLEX"
  glue_version      = "4.0"
  tags = {
    Environment = "production"
  }
  default_arguments = {
    "--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ",")
    "--DATA" = "2023-01"
  }
  command {
    name            = "glueetl"
    script_location = "s3://nyc-taxis-glue-scripts/scripts/green-taxi/job_green_raw_to_bronze.py"
    python_version  = "3"
  }
  depends_on = [local_file.requirements_hash]
}

resource "aws_glue_job" "job_yellow_raw_to_bronze" {
  name              = "job_yellow_raw_to_bronze"
  role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault"
  worker_type       = "G.1X"
  number_of_workers = 5
  timeout           = 10
  execution_class   = "FLEX"
  glue_version      = "4.0"
  tags = {
    Environment = "production"
  }
  default_arguments = {
    "--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ",")
    "--DATA" = "2023-01"
  }
  command {
    name            = "glueetl"
    script_location = "s3://nyc-taxis-glue-scripts/scripts/yellow-taxi/job_yellow_raw_to_bronze.py"
    python_version  = "3"
  }
  depends_on = [local_file.requirements_hash]
}
