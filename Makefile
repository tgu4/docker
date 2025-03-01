PYTHON_VER=3.12
COMPOSE = docker-compose
COMPOSE_FILE=docker-compose.yml
IMAGE_NAME=mysl
CONTAINER_NAME=mysl_container

.PHONY: build
build: stop
	docker rmi -f $(IMAGE_NAME) || true
	docker rm -f $(CONTAINER_NAME) || true
	$(COMPOSE) build --no-cache --parallel

## start/stop
.PHONY: start
start:
	$(COMPOSE) -f $(COMPOSE_FILE) up -d

.PHONY: stop
stop:
	$(COMPOSE) -f $(COMPOSE_FILE) down

.PHONY: reload
reload: stop start

.PHONY: rebuild
rebuild: build start

.PHONY: clean
clean: stop
	docker rmi -f $(IMAGE_NAME)
	find . -type f -name '*.pyc' -delete -o -type d -name __pycache__ -delete

## shells
.PHONY: bash
bash: start
	docker exec -ti $(CONTAINER_NAME) bash

.PHONY: black
black:
	docker exec $(CONTAINER_NAME) python$(PYTHON_VER) -m black --check .

.PHONY: help
help:
	@echo ""
	@echo "Available commands:"
	@echo ""
	@echo "  make start     - Start the container in detached mode"
	@echo "  make stop     - Stop the running container"
	@echo "  make reload   - Stop & Start the container"
	@echo "  make clean    - Stop and remove containers, networks, and images"
	@echo "  make bash     - Log into the container's bash shell"
	@echo "  make blak     - Check black format"
	@echo "  make help     - Show this help message"
	@echo ""
