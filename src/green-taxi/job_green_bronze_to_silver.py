import sys
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, to_timestamp

sc = SparkContext()
glueContext = GlueContext(sc)

def main():
	args = getResolvedOptions(sys.argv, ['DATA'])
	data = args['DATA']
	data_partition = data.replace("-", "")

	# Lê do catálogo bronze usando DynamicFrame, filtrando pela partição YEAR_MONTH
	df_bronze = glueContext.create_dynamic_frame.from_catalog(
		database="db_bronze",
		table_name="tb_green_taxi",
		push_down_predicate=f"year_month == {data_partition}"
	)

	# Converte para Spark DataFrame
	df = df_bronze.toDF()

	# Corrige os datatypes conforme tabela silver
	df = df.withColumn("VendorID", col("VendorID").cast("int")) \
		   .withColumn("lpep_pickup_datetime", to_timestamp(col("lpep_pickup_datetime"))) \
		   .withColumn("lpep_dropoff_datetime", to_timestamp(col("lpep_dropoff_datetime"))) \
		   .withColumn("store_and_fwd_flag", col("store_and_fwd_flag").cast("string")) \
		   .withColumn("RatecodeID", col("RatecodeID").cast("int")) \
		   .withColumn("PULocationID", col("PULocationID").cast("int")) \
		   .withColumn("DOLocationID", col("DOLocationID").cast("int")) \
		   .withColumn("passenger_count", col("passenger_count").cast("int")) \
		   .withColumn("trip_distance", col("trip_distance").cast("double")) \
		   .withColumn("fare_amount", col("fare_amount").cast("double")) \
		   .withColumn("extra", col("extra").cast("double")) \
		   .withColumn("mta_tax", col("mta_tax").cast("double")) \
		   .withColumn("tip_amount", col("tip_amount").cast("double")) \
		   .withColumn("tolls_amount", col("tolls_amount").cast("double")) \
		   .withColumn("improvement_surcharge", col("improvement_surcharge").cast("double")) \
		   .withColumn("total_amount", col("total_amount").cast("double")) \
		   .withColumn("payment_type", col("payment_type").cast("int")) \
		   .withColumn("trip_type", col("trip_type").cast("int")) \
		   .withColumn("congestion_surcharge", col("congestion_surcharge").cast("double"))

	# Adiciona coluna de partição
	df = df.withColumn("year_month", col("year_month").cast("int"))

	# Converte de volta para DynamicFrame
	df_silver = DynamicFrame.fromDF(df, glueContext, "df_silver")

	# Grava no catálogo silver
	glueContext.write_dynamic_frame.from_catalog(
		frame=df_silver,
		database="db_silver",
		table_name="tb_green_taxi",
		additional_options={"partitionKeys": ["year_month"]},
		format="parquet"
	)

if __name__ == "__main__":
	main()
