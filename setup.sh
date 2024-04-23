# Start Zookeeper
bin/zookeeper-server-start.sh config/zookeeper.properties
# start kafka
bin/kafka-server-start.sh config/server.properties

# Start Spark 
sbin/start-all.sh

# star the spark shell with two packages to connect spark with cassandra and kafka 
# or you can download cassandra and kafka connector files and add --jars  
bin/spark-shell --packages "com.datastax.spark:spark-cassandra-connector_2.11:2.0.2","org.apache.spark:spark-streaming-kafka-0-8_2.11:2.0.0"

