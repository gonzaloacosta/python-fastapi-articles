USERNAME		:= gonzalo
REPOSITORY  	:= gonzaloacosta
IMAGE			:= python-fastapi-articles
HOST_PORT 		:= 8080
HOST_IP			:= localhost
#HOST_IP			:= gap-dev-nlb-4ce75e8689217918.elb.us-east-1.amazonaws.com
CONTAINER_PORT	:= 80
VERSION			:= 0.0.4

venv:
	@python3 -m venv venv
	@pip3 install -r requirements.txt

activate:
	@source venv/bin/activate

run:
	@cd app && uvicorn main:app --host $(HOST_IP) --port $(HOST_PORT) --reload

test:
	@echo "GET /"
	@curl -vs http://$(HOST_IP):$(HOST_PORT)
	@echo ""
	@echo "POST /article"
	@curl -vs -X POST http://$(HOST_IP):$(HOST_PORT)/article -H 'Content-Type: application/json' -d '{"username":"someone","text":"to something else, butterfly"}' | jq .
	@echo ""
	@echo "GET /articles"
	@curl -vs -X GET http://$(HOST_IP):$(HOST_PORT)/articles | jq .
	@echo ""
	@echo "GET /1"
	@curl -vs http://$(HOST_IP):$(HOST_PORT)/article/1 | jq .
	@echo ""

docs:
	@open http://$(HOST_IP):$(HOST_PORT)/docs

docker/build:
	@docker build -t $(REPOSITORY)/$(IMAGE):$(VERSION) .

docker/image:
	@docker image -f $(REPOSITORY)/$(IMAGE):$(VERSION)

docker/push:
	@docker push $(REPOSITORY)/$(IMAGE):$(VERSION)

docker/run:
	@docker run --rm -d --name $(USERNAME)-$(IMAGE) -p $(HOST_PORT):$(CONTAINER_PORT) $(REPOSITORY)/$(IMAGE):$(VERSION)

docker/status:
	@docker ps -f name=$(USERNAME)-$(IMAGE)
