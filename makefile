# Variables
DOCKER_TAG := gerald-lbn
APPS_DIR := apps
APP_IMAGE := $(DOCKER_TAG)/lyriks-app
WORKER_IMAGE := $(DOCKER_TAG)/lyriks-worker
DEV_COMPOSE := dev.compose.yml

# Default target
.DEFAULT_GOAL := help

# Build targets
.PHONY: build-web build-worker build
build-web:
	docker build -t $(APP_IMAGE) -f $(APPS_DIR)/web/Dockerfile .

build-worker:
	docker build -t $(WORKER_IMAGE) -f $(APPS_DIR)/worker/Dockerfile .

build: build-web build-worker

# Docker Compose targets
.PHONY: up down dev-up dev-down
up:
	docker-compose up -d --force-recreate

down:
	docker-compose down

# dev-up:
# 	docker-compose -f $(DEV_COMPOSE) up -d

# dev-down:
# 	docker-compose -f $(DEV_COMPOSE) down

# Clean targets
.PHONY: clean clean-web clean-worker
clean-web:
	cd ${APPS_DIR}/web && rm -rf .turbo build node_modules

clean-worker:
	cd ${APPS_DIR}/worker && rm -rf .turbo build node_modules

clean-packages:
	cd packages && rm -rf ./*/node_modules

clean: clean-web clean-worker clean-packages
	rm -rf ./out
	rm -rf node_modules

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build-web       Build the web application Docker image"
	@echo "  build-worker    Build the worker Docker image"
	@echo "  build           Build both the web application and worker Docker images"
	@echo "  clean-web       Clean the web application build artifacts"
	@echo "  clean-worker    Clean the worker build artifacts"
	@echo "  clean-packages  Clean node_modules in all packages"
	@echo "  clean           Clean all build artifacts"
	@echo "  up              Start services using docker-compose"
	@echo "  down            Stop services using docker-compose"
	@echo "  help            Show this help message"
