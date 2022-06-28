#echo "POST /article"
#curl -v -H 'appname:local-test-quark-header' -X POST http://localhost:9081/article\?appname="local-test-query" -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Another day in the office", "appname": "local-test-body", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

#curl -v -X POST http://localhost:9081/article\?appname=local-test-query -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Another day in the office", "appname": "local-test-body", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

#curl -v -X POST http://localhost:9081/article -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Another day in the office", "appname": "local-test-body", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

curl -v -X POST http://localhost:9081/article -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Another day in the office", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

#curl -v -X POST http://localhost:9081/article -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Another day in the office", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .
#echo "GET /articles"
#curl -v http://localhost:9081/articles | jq .

#echo "GET /article/1"
#curl -v -H "header1:value1" -H "header2:value2" http://localhost:9081/article/1 | jq .
