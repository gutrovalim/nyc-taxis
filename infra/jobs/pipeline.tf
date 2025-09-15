resource "aws_glue_workflow" "nyc_taxi_etl" {
  name = "nyc_taxi_etl_workflow"
  description = "Workflow ETL para pipeline NYC Taxi."
}

resource "aws_glue_trigger" "bronze_to_silver" {
  name     = "trigger_bronze_to_silver"
  type     = "ON_DEMAND"
  workflow_name = aws_glue_workflow.nyc_taxi_etl.name

  actions {
    job_name = aws_glue_job.job_green_bronze_to_silver.name
  }
  actions {
    job_name = aws_glue_job.job_yellow_bronze_to_silver.name
  }
}

resource "aws_glue_trigger" "silver_to_gold" {
  name     = "trigger_silver_to_gold"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.nyc_taxi_etl.name

  actions {
    job_name = aws_glue_job.job_green_silver_to_gold.name
  }
  actions {
    job_name = aws_glue_job.job_yellow_silver_to_gold.name
  }
  predicate {
    conditions {
      job_name = aws_glue_job.job_green_bronze_to_silver.name
      state    = "SUCCEEDED"
    }
    conditions {
      job_name = aws_glue_job.job_yellow_bronze_to_silver.name
      state    = "SUCCEEDED"
    }
  }
}
