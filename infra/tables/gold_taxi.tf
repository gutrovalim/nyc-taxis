resource "aws_glue_catalog_table" "tb_gold_taxi" {
  name          = "tb_gold_taxi"
  database_name = "db_gold"
  depends_on    = [aws_glue_catalog_database.db_gold]

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "SNAPPY"
  }

  storage_descriptor {
    location      = "s3://nyc-taxis-gold/taxi/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "tb_gold_taxi"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name    = "VendorID"
      type    = "int"
      comment = "Código do provedor do taxi. 1=Creative Mobile Technologies, LLC; 2=Curb Mobility, LLC; 6=Myle Technologies Inc; 7=Helix"
    }
    columns {
      name    = "passenger_count"
      type    = "int"
      comment = "Número de passageiros"
    }
    columns {
      name    = "total_amount"
      type    = "double"
      comment = "Valor total cobrado (sem gorjeta em dinheiro)"
    }
    columns {
      name    = "pickup_datetime"
      type    = "timestamp"
      comment = "Data/hora início da corrida"
    }
    columns {
      name    = "dropoff_datetime"
      type    = "timestamp"
      comment = "Data/hora fim da corrida"
    }
    columns {
      name    = "taxi_type"
      type    = "string"
      comment = "Tipo do taxi: 'yellow' ou 'green'"
    }
  }
       partition_keys {
        name = "year_month"
        type = "int"
    }
}
