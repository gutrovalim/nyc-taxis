import sys
import pyarrow.parquet as pq
import pyarrow as pa
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from pyspark.sql.functions import lit

sc = SparkContext()
glueContext = GlueContext(sc)

def main():

    args = getResolvedOptions(sys.argv, ['DATA'])
    data = args['DATA']
    data_partition = data.replace("-", "")

    input_path = f"s3://nyc-taxis-raw/yellow_tripdata/{data_partition}/yellow_tripdata_{data}.parquet"

    # Leitura do Parquet direto como Spark DataFrame
    df_spark = glueContext.spark_session.read.parquet(input_path)

    # Normalizar para string
    for col_name in df_spark.columns:
        df_spark = df_spark.withColumn(col_name, df_spark[col_name].cast("string"))

    # Adiciona coluna 'year_month' para particionamento
    df_spark = df_spark.withColumn("year_month", lit(data_partition))

    # Converter para DynamicFrame apenas para gravar no Glue Catalog
    df = DynamicFrame.fromDF(df_spark, glueContext, "df_with_partition")

    # Escrever no Glue Catalog
    glueContext.write_dynamic_frame.from_catalog(
        frame=df,
        database="db_bronze",
        table_name="tb_yellow_taxi",
        additional_options={
            "partitionKeys": ["year_month"]
        },
        format="parquet"
    )

if __name__ == "__main__":
    main()
