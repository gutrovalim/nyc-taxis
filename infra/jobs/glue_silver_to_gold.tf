resource "aws_glue_job" "job_green_silver_to_gold" {
	worker_type        = "G.1X"
	number_of_workers  = 2
	timeout            = 10
	max_retries        = 2
	execution_class    = "FLEX"
	tags = {
		Environment = "production"
	}
		default_arguments = {
			"--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ",")
		}
		depends_on = [local_file.requirements_hash]
	name     = "job_green_silver_to_gold"
	role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault"
	command {
		name            = "glueetl"
		script_location = "s3://nyc-taxis-glue-scripts/scripts/green-taxi/job_green_silver_to_gold.py"
		python_version  = "3"
	}
	glue_version = "4.0"
}

resource "aws_glue_job" "job_yellow_silver_to_gold" {
	worker_type        = "G.1X"
	number_of_workers  = 2
	timeout            = 10
	max_retries        = 2
	execution_class    = "FLEX"
	tags = {
		Environment = "production"
	}
		default_arguments = {
			"--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ",")
		}
		depends_on = [local_file.requirements_hash]
	name     = "job_yellow_silver_to_gold"
	role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault"
	command {
		name            = "glueetl"
		script_location = "s3://nyc-taxis-glue-scripts/scripts/yellow-taxi/job_yellow_silver_to_gold.py"
		python_version  = "3"
	}
	glue_version = "4.0"
}
