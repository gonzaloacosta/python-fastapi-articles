USERNAME		:= gonzalo
REPOSITORY  	:= gonzaloacosta
IMAGE			:= python-fastapi-articles
HOST_PORT 		:= 40792
HOST_IP			:= localhost
CONTAINER_PORT	:= 80
VERSION			:= 0.0.2

venv:
	@python3 -m venv venv
	@pip3 install -r requirements.txt

activate:
	@source venv/bin/activate

run:
	@cd app && uvicorn main:app --host $(HOST_IP) --port $(HOST_PORT) --reload

test:
	@echo "GET /"
	@curl http://$(HOST_IP):$(HOST_PORT)
	@echo ""
	@echo ""
	@echo "POST /article"
	@curl -X POST http://$(HOST_IP):$(HOST_PORT)/article -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Content-Type of your request to application/json and pass the "}' | jq . 
	@echo ""
	@echo "GET /articles"
	@curl -X GET http://$(HOST_IP):$(HOST_PORT)/articles | jq . 
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
