# cb-kafka-connect
Couchbase all in one Kafka Environment

## WHATS IN THE BOX
Builds a ready to use microservice environment using docker-compose   
- Couchbase Service   
- Zookeeper  
- Schema Registry  
- Kafka Broker   
- Kafka Connect   
- Kafka Rest Client

## REQUIREMENTS
- **Clone this repo**   
- **docker-compose version 1.11 (support for version 3 yml) or greater**   
- **Assign docker at least 5 gigs of memory**   
- **To run and build in one command**   
docker-compose up --build -d   
- **To list topics**   
curl "http://localhost:8082/topics"   
- **To list connectors**   
curl "http://localhost:8083/connectors"   
- **To send create an AVRO document and send it to a new topic**   
curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \   
-H "Accept: application/vnd.kafka.v2+json" \   
--data '{"key_schema": "{\"name\":\"user_id\"  ,\"type\": \"int\"   }", "value_schema": "{\"type\": \"record\", \"name\": \"User\", \"fields\": [{\"name\": \"name\", \"type\": \"string\"}]}", "records": [{"key" : 1 , "value": {"name": "testUser"}}]}' \   
"http://localhost:8082/topics/bar"  
- **Initialize a sink to Couchbase using the Couchbase Kafka Connector**   
curl -X POST -H "Content-Type: application/json" \   
     --data '{"name": "cb", "config": {"connector.class":"com.couchbase.connect.kafka.CouchbaseSinkConnector","tasks.max":"1", "topics":"bar","connection.cluster_address":"cbdb","connection.bucket":"receiver","connection.password":"passreceiver"}}' \   
    "http://localhost:8083/connectors"
