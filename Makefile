.PHONY: build test

CI_REGISTRY_IMAGE ?= papyri-docker
CI_COMMIT_SHORT_SHA ?= $(shell basename $(shell git rev-parse --show-toplevel))

build:
	docker compose -f docker-compose-test.yml build

test:
	docker compose -f docker-compose-test.yml run -e GITHUB_TOKEN -e GITHUB_USERNAME selenium_ui_tests --abort-on-container-exit --exit-code-from app
