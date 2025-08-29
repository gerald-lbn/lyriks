# Variables
DOCKER_TAG := gerald-lbn
APPS_DIR := apps
APP_IMAGE := $(DOCKER_TAG)/lyriks-app
docs_IMAGE := $(DOCKER_TAG)/lyriks-docs
DEV_COMPOSE := dev.compose.yml

# Default target
.DEFAULT_GOAL := help

# Build targets
.PHONY: build-web build-docs build
build-web:
	docker build -t $(APP_IMAGE) -f $(APPS_DIR)/web/Dockerfile .

build-docs:
	docker build -t $(docs_IMAGE) -f $(APPS_DIR)/docs/Dockerfile .

build: build-web build-docs

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
.PHONY: clean clean-web clean-docs
clean-web:
	cd ${APPS_DIR}/web && rm -rf .turbo build node_modules

clean-docs:
	cd ${APPS_DIR}/docs && rm -rf .turbo build node_modules

clean-packages:
	cd packages && rm -rf ./*/node_modules

clean: clean-web clean-docs clean-packages
	rm -rf ./out
	rm -rf node_modules

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build-web       Build the web application Docker image"
	@echo "  build-docs   	 Build the docs Docker image"
	@echo "  build           Build both the web application and docs Docker images"
	@echo "  clean-web       Clean the web application build artifacts"
	@echo "  clean-docs   	 Clean the docs build artifacts"
	@echo "  clean-packages  Clean node_modules in all packages"
	@echo "  clean           Clean all build artifacts"
	@echo "  up              Start services using docker-compose"
	@echo "  down            Stop services using docker-compose"
	@echo "  help            Show this help message"
