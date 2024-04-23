spark.stop # stopping the deafult spark repl session to create our own session

from pyspark.sql import SparkSession
from pyspark.streaming import StreamingContext
from pyspark.sql.functions import explode, split

spark = SparkSession.builder \
    .appName("KafkaSparkStreaming") \
    .config("spark.cassandra.connection.host", "127.0.0.1") \
    .getOrCreate()

# Read from Kafka topic
df = spark \
  .readStream \
  .format("kafka") \
  .option("kafka.bootstrap.servers", "localhost:9092") \
  .option("subscribe", "mytopic") \
  .load()

# Define a function to save RDD to Cassandra
def save_to_cassandra(rdd):
    rdd.toDF() \
       .selectExpr("split(value, ',') as arr") \
       .selectExpr("arr[0] as fname", "arr[1] as lname", "arr[2] as url", "arr[3] as product", "arr[4] as cnt") \
       .write \
       .format("org.apache.spark.sql.cassandra") \
       .options(table="cust_data", keyspace="sparkdata") \
       .mode("append") \
       .save()

# Apply the save_to_cassandra function to the DataFrame
query = df \
    .selectExpr("CAST(value AS STRING)") \
    .writeStream \
    .outputMode("append") \
    .foreachBatch(save_to_cassandra) \
    .start()

query.awaitTermination()

