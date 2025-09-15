
resource "aws_glue_job" "job_silver_to_gold" {
  worker_type        = "G.1X"
  number_of_workers  = 5
  timeout            = 10
  execution_class    = "FLEX"
  tags = {
	Environment = "production"
  }
  default_arguments = {
	"--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ","),
    "--DATA" = "2023-01"
  }
  depends_on = [local_file.requirements_hash]
  name     = "job_silver_to_gold"
  role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault"
  command {
	name            = "glueetl"
	script_location = "s3://nyc-taxis-glue-scripts/scripts/job_silver_to_gold.py"
	python_version  = "3"
  }
  glue_version = "4.0"
}
