COMPOSE_FILE=docker-compose.yml
IMAGE_NAME=mysl
CONTAINER_NAME=mysl_container

## start/stop
start:
	docker-compose -f $(COMPOSE_FILE) up -d

stop:
	docker-compose -f $(COMPOSE_FILE) down

reload: stop start

clean: stop
	docker rmi -f $(IMAGE_NAME)
	find . -type f -name '*.pyc' -delete -o -type d -name __pycache__ -delete

## shells
bash:
	docker exec -ti $(CONTAINER_NAME) bash

black:
	docker exec $(CONTAINER_NAME) python$(PYTHON_VER) -m black --check .
