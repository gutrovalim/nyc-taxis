resource "aws_s3_bucket" "nyc_taxi_scripts" {
  bucket = "nyc-taxis-glue-scripts"
}

resource "aws_s3_bucket" "nyc_taxis_bronze" {
  bucket = "nyc-taxis-bronze"
}

resource "aws_s3_bucket" "nyc_taxis_silver" {
  bucket = "nyc-taxis-silver"
}

resource "aws_s3_bucket" "nyc_taxis_gold" {
  bucket = "nyc-taxis-gold"
}

resource "aws_s3_bucket" "nyc_taxis_raw" {
  bucket = "nyc-taxis-raw"
}

# Upload all scripts from the local src/ directory to the nyc-taxi-scripts bucket
resource "aws_s3_bucket_object" "scripts" {
  for_each   = fileset("${path.root}/src", "**/*")
  bucket     = aws_s3_bucket.nyc_taxi_scripts.id
  key        = "scripts/${each.value}"
  source     = "${path.root}/src/${each.value}"
  etag       = filemd5("${path.root}/src/${each.value}")
  depends_on = [aws_s3_bucket.nyc_taxi_scripts]
}