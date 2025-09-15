import sys
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import col, lit

sc = SparkContext()
glueContext = GlueContext(sc)

def main():
    args = getResolvedOptions(sys.argv, ['DATA'])
    data = args['DATA']
    data_partition = data.replace("-", "")

    # Lê do catálogo silver - green
    df_green = glueContext.create_dynamic_frame.from_catalog(
        database="db_silver",
        table_name="tb_green_taxi",
        push_down_predicate=f"year_month == {data_partition}"
    ).toDF()

    # Lê do catálogo silver - yellow
    df_yellow = glueContext.create_dynamic_frame.from_catalog(
        database="db_silver",
        table_name="tb_yellow_taxi",
        push_down_predicate=f"year_month == {data_partition}"
    ).toDF()

    # Seleciona e renomeia colunas para o padrão gold
    df_green_gold = df_green.select(
        col("VendorID").cast("int"),
        col("passenger_count").cast("int"),
        col("total_amount").cast("double"),
        col("lpep_pickup_datetime").alias("pickup_datetime").cast("timestamp"),
        col("lpep_dropoff_datetime").alias("dropoff_datetime").cast("timestamp"),
        col("year_month").cast("int")
    ).withColumn("taxi_type", lit("green"))

    df_yellow_gold = df_yellow.select(
        col("VendorID").cast("int"),
        col("passenger_count").cast("int"),
        col("total_amount").cast("double"),
        col("tpep_pickup_datetime").alias("pickup_datetime").cast("timestamp"),
        col("tpep_dropoff_datetime").alias("dropoff_datetime").cast("timestamp"),
        col("year_month").cast("int")
    ).withColumn("taxi_type", lit("yellow"))

    # Empilha os dois DataFrames
    df_gold = df_green_gold.unionByName(df_yellow_gold)

    # Converte para DynamicFrame
    df_gold_dyn = DynamicFrame.fromDF(df_gold, glueContext, "df_gold")

    # Grava no catálogo gold
    glueContext.write_dynamic_frame.from_catalog(
        frame=df_gold_dyn,
        database="db_gold",
        table_name="tb_gold_taxi",
        additional_options={"partitionKeys": ["year_month"]},
        format="parquet"
    )

if __name__ == "__main__":
    main()