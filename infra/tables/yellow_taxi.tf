resource "aws_glue_catalog_table" "tb_yellow_taxi" {
	name          = "tb_yellow_taxi"
	database_name = "db_bronze"
	depends_on    = [aws_glue_catalog_database.db_bronze]

	table_type = "EXTERNAL_TABLE"

	parameters = {
		EXTERNAL              = "TRUE"
		"parquet.compression" = "SNAPPY"
	}

	storage_descriptor {
	location      = "s3://nyc-taxis-bronze/tb_yellow_taxi"
		input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
		output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

		ser_de_info {
			name                  = "tb_yellow_taxi"
			serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
			parameters = {
				"serialization.format" = 1
			}
		}

		columns {
			name    = "VendorID"
			type    = "int"
			comment = "Código do provedor TPEP. 1=Creative Mobile Technologies, LLC; 2=Curb Mobility, LLC; 6=Myle Technologies Inc; 7=Helix"
		}
		columns {
			name    = "tpep_pickup_datetime"
			type    = "timestamp"
			comment = "Data/hora início da corrida (TPEP)"
		}
		columns {
			name    = "tpep_dropoff_datetime"
			type    = "timestamp"
			comment = "Data/hora fim da corrida (TPEP)"
		}
		columns {
			name    = "passenger_count"
			type    = "int"
			comment = "Número de passageiros"
		}
		columns {
			name    = "trip_distance"
			type    = "double"
			comment = "Distância da corrida em milhas"
		}
		columns {
			name    = "RatecodeID"
			type    = "int"
			comment = "Código da tarifa final. 1=Standard; 2=JFK; 3=Newark; 4=Nassau/Westchester; 5=Negociada; 6=Grupo; 99=Null"
		}
		columns {
			name    = "store_and_fwd_flag"
			type    = "string"
			comment = "Flag de armazenamento e envio. Y=store and forward; N=not store and forward"
		}
		columns {
			name    = "PULocationID"
			type    = "int"
			comment = "Zona TLC de início da corrida"
		}
		columns {
			name    = "DOLocationID"
			type    = "int"
			comment = "Zona TLC de fim da corrida"
		}
		columns {
			name    = "payment_type"
			type    = "int"
			comment = "Tipo de pagamento. 0=Flex; 1=Cartão; 2=Dinheiro; 3=Sem cobrança; 4=Disputa; 5=Desconhecido; 6=Cancelado"
		}
		columns {
			name    = "fare_amount"
			type    = "double"
			comment = "Valor calculado pelo taxímetro"
		}
		columns {
			name    = "extra"
			type    = "double"
			comment = "Extras e sobretaxas"
		}
		columns {
			name    = "mta_tax"
			type    = "double"
			comment = "Taxa MTA"
		}
		columns {
			name    = "tip_amount"
			type    = "double"
			comment = "Valor da gorjeta (apenas cartão)"
		}
		columns {
			name    = "tolls_amount"
			type    = "double"
			comment = "Total de pedágios"
		}
		columns {
			name    = "improvement_surcharge"
			type    = "double"
			comment = "Sobretaxa de melhoria"
		}
		columns {
			name    = "total_amount"
			type    = "double"
			comment = "Valor total cobrado (sem gorjeta em dinheiro)"
		}
		columns {
			name    = "congestion_surcharge"
			type    = "double"
			comment = "Valor da sobretaxa de congestionamento NYS"
		}
		columns {
			name    = "airport_fee"
			type    = "double"
			comment = "Taxa de aeroporto (apenas pickups em LGA/JFK)"
		}
		columns {
			name    = "cbd_congestion_fee"
			type    = "double"
			comment = "Taxa de congestionamento MTA (desde 2025)"
		}
	}
}
