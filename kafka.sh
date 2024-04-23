# Create topic
bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic mytopic
# check the topics 
bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# create a Producer 
bin/kafka-console-producer.sh --broker-list localhost:9092 --topic mytopic

# create a consumer to check the data from begining 
bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic mytopic --from-beginning