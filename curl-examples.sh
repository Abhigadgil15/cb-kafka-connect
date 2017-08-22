#!/bin/bash
##################################################
##  Curl Script to demonstrate using the kafka rest
##    client to add a topic, and a connectors to use the
##    kafka sink to write to Couchbase
##################################################

## List Topics
curl -X GET "http://localhost:8082/topics" -w "\n"

curl -X GET "http://localhost:8083/connectors/" -w "\n"

## Send a JSON document and specify the key
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" -H "Accept: application/vnd.kafka.v2+json" \
  --data '
{
  "records": [
    {
      "key": {"schema": {"type":"string"}, "payload": "kafka::foo"},
      "value": {"foo": "bar"}
    }
  ]
}' http://localhost:8082/topics/a_topic_with_json -w "\n"

## Send different "schema" json document and key schema
curl -X POST -H "Content-Type: application/vnd.kafka.json.v2+json" -H "Accept: application/vnd.kafka.v2+json" \
  --data '
{
  "records": [
    {
      "key": {"schema": {"type":"string"}, "payload": "kafka::bar"},
      "value": {"foo": "bar", "more_foo":[{"foo":"bar"}]}
    }
  ]
}' http://localhost:8082/topics/a_topic_with_json -w "\n"

## Create Connector
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

## Delete Connector
## curl -X DELETE localhost:8083/connectors/
