# cb-kafka-connect
Couchbase all in one Kafka Environment

## WHATS IN THE BOX
Builds a ready to use microservice environment using docker-compose   
- Couchbase Service   
- Zookeeper  
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
- **To create new document and send it to a new topic**   
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" -H "Accept: application/vnd.kafka.v2+json" \
  --data ' {
  "records": [
    {"key": {"schema": {"type":"string"},
     "payload": "kafka::bar"},
     "value": {"bar": "some random value", "bar_json_array_data":[
	{"bar":"some random json value in an array"}],
	"an_array_of_digits":[1,2,3,4,5,6]}
    }
  ]
}' http://localhost:8082/topics/a_topic_with_json -w "\n"
- **Initialize a sink to Couchbase using the Couchbase Kafka Connector**   
curl -X POST -H "Content-Type: application/json" --data '
  {"name": "cb",
   "config": {
     "connector.class":"com.couchbase.connect.kafka.CouchbaseSinkConnector",
     "tasks.max":"1",
     "topics":"a_topic_with_json",
     "connection.cluster_address":"cbdb",
     "connection.bucket":"receiver",
     "key.converter": "org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable": true,
     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable": false
}}' http://localhost:8083/connectors -w "\n"
