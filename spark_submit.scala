spark.stop # stopping the deafult spark repl session to create our own session

import scala.Product
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext._
import org.apache.spark.streaming._
import org.apache.spark.streaming.StreamingContext._
import org.apache.spark.streaming.kafka._

import com.datastax.spark.connector.SomeColumns
import com.datastax.spark.connector.cql.CassandraConnector
import com.datastax.spark.connector.streaming._

val sparkConf = new SparkConf().setAppName("KafkaSparkStreaming").set("spark.cassandra.connection.host","127.0.0.1")
val ssc = new StreamingContext(sparkConf, Seconds(20))
val topicpMap = "mytopic".split(",").map((_, 1.toInt)).toMap
val lines = KafkaUtils.createStream(ssc, "localhost:2181","sparkgroup",topicpMap).map(_._2)
lines.print();
lines.map(line => { val arr = line.split(","); (arr(0),arr(1),arr(2),arr(3)) }).saveToCassandra("sparkdata","cust_data", SomeColumns("fname","lname","url","product","cnt"))
ssc.start
ssc.awaitTermination