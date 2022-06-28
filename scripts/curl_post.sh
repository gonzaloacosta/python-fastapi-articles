echo "POST /article"
curl -ks -X POST https://articles.example.com/article -H 'Content-Type: application/json' -d '{"username":"someone","text":"Another day in the office", "appname": "local-test-app", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

echo "GET /articles"
curl -ks https://articles.example.com/articles | jq .

echo "GET /article/1"
curl -ks https://articles.example.com/article/1 | jq .
