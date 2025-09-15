resource "aws_glue_job" "job_green_bronze_to_silver" {
	worker_type        = "G.1X"
	number_of_workers  = 5
	timeout            = 10
	execution_class    = "FLEX"
	tags = {
		Environment = "production"
	}
		default_arguments = {
			"--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ",")
			"--DATA" = "2023-01"
		}
	name     = "job_green_bronze_to_silver"
	role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault" # ajuste para seu ARN
	command {
		name            = "glueetl"
		script_location = "s3://nyc-taxis-glue-scripts/scripts/green-taxi/job_green_bronze_to_silver.py"
		python_version  = "3"
	}
	glue_version = "4.0"
}

resource "aws_glue_job" "job_yellow_bronze_to_silver" {
	worker_type        = "G.1X"
	number_of_workers  = 5
	timeout            = 10
	execution_class    = "FLEX"
	tags = {
		Environment = "production"
	}
		default_arguments = {
			"--additional-python-modules" = replace(trimspace(file("${path.module}/../../requirements.txt")), "\n", ",")
			"--DATA" = "2023-01"
		}
	name     = "job_yellow_bronze_to_silver"
	role_arn = "arn:aws:iam::182205399724:role/AWSGlueServiceRoleDefault"
	command {
		name            = "glueetl"
		script_location = "s3://nyc-taxis-glue-scripts/scripts/yellow-taxi/job_yellow_bronze_to_silver.py"
		python_version  = "3"
	}
	glue_version = "4.0"
}
