USERNAME		:= gonza
REPOSITORY  	:= gonzaloacosta
IMAGE			:= fastapi-articles
HOST_PORT 		:= 8000
CONTAINER_PORT	:= 80
VERSION			:= 0.0.1

venv:
	@python3 -m venv venv
	@pip3 install -r requirements.txt

activate:
	@source venv/bin/activate

run:
	@cd app && uvicorn main:app --host 127.0.0.1 --port $(HOST_PORT) --reload

test:
	@curl http://localhost:$(HOST_PORT)/$(BASE_PATH)

docs:
	@open http://localhost:8000/docs

docker/build:
	@docker build -t $(REPOSITORY)/$(IMAGE):$(VERSION) .

docker/run:
	@docker run --rm -d --name $(USERNAME)-$(IMAGE) -p $(HOST_PORT):$(CONTAINER_PORT) $(REPOSITORY)/$(IMAGE):$(VERSION)

docker/status:
	@docker ps -a 
