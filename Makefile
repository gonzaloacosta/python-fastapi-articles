USERNAME		:= gonzalo
REPOSITORY  	:= gonzaloacosta
IMAGE			:= python-fastapi-articles
HOST_PORT 		:= 8080
HOST_IP			:= localhost
CONTAINER_PORT	:= 80
VERSION			:= 0.0.8
BRANCH			:= master

py/venv:
	@python3 -m venv venv
	@pip3 install -r requirements.txt

py/activate:
	@source venv/bin/activate

py/run:
	@cd app && uvicorn main:app --host $(HOST_IP) --port $(HOST_PORT) --reload

test:
	@echo "$(shell date) - GET /"
	@curl -s http://$(HOST_IP):$(HOST_PORT) | jq .
	@echo ""
	@echo "$(shell date) - POST /article"
	@curl -vs -X POST http://$(HOST_IP):$(HOST_PORT)/article -H 'Content-Type: application/json' -d "{\"username\":\"someone\",\"text\":\"Daily note $(shell date ): to something else, butterfly\", \"appname\": \"local-test-app\", \"request_id\": \"ac832ad4-c9c9-4eda-82ac-651233d23f2b\", \"wait_time\": \"3\"}" | jq .
	@echo ""
	@echo "GET /articles"
	@curl -vs -X GET http://$(HOST_IP):$(HOST_PORT)/articles | jq .
	@echo ""
	@echo "GET /1"
	@curl -vs http://$(HOST_IP):$(HOST_PORT)/article/1 | jq .
	@echo ""
	@echo "GET /3"
	@curl -vs http://$(HOST_IP):$(HOST_PORT)/article/3 | jq .
	@echo ""

g/checkout:
	@git checkout $(BRANCH)

g/commit:
	@git commit -am "bump $(VERSION)"

g/push:
	@git commit -am "bump $(VERSION)"
	@git push -u origin $(BRANCH)

g/pull:
	@git fetch --force
	@git pull

docs:
	@open http://$(HOST_IP):$(HOST_PORT)/docs

d/build:
	@docker build -t $(REPOSITORY)/$(IMAGE):$(VERSION) .

d/image:
	@docker image -f $(REPOSITORY)/$(IMAGE):$(VERSION)

d/push:
	@docker push $(REPOSITORY)/$(IMAGE):$(VERSION)

d/bump:
	@docker build -t $(REPOSITORY)/$(IMAGE):$(VERSION) .
	@docker tag $(REPOSITORY)/$(IMAGE):$(VERSION) $(REPOSITORY)/$(IMAGE):latest
	@docker push $(REPOSITORY)/$(IMAGE):$(VERSION)
	@docker push $(REPOSITORY)/$(IMAGE):latest

d/rebuild:
	@docker stop $(USERNAME)-$(IMAGE)
	@docker rm $(USERNAME)-$(IMAGE)
	@docker run --rm -d --name $(USERNAME)-$(IMAGE) -p $(HOST_PORT):$(CONTAINER_PORT) $(REPOSITORY)/$(IMAGE):$(VERSION)

d/run:
	@docker run --rm -d --name $(USERNAME)-$(IMAGE) -p $(HOST_PORT):$(CONTAINER_PORT) $(REPOSITORY)/$(IMAGE):$(VERSION)

d/status:
	@docker ps -f name=$(USERNAME)-$(IMAGE)

k/apply:
	@kubectl apply -f kubernetes/*.yaml
