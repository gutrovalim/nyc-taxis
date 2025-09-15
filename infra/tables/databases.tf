resource "aws_glue_catalog_database" "db_bronze" {
  name = "db_bronze"
}

resource "aws_glue_catalog_database" "db_silver" {
  name = "db_silver"
}

resource "aws_glue_catalog_database" "db_gold" {
  name = "db_gold"
}