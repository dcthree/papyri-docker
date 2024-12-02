.PHONY: build test

CI_REGISTRY_IMAGE ?= papyri-docker
CI_COMMIT_SHORT_SHA ?= $(shell basename $(shell git rev-parse --show-toplevel))

build:
	docker compose -f docker-compose-test.yml build

test:
	echo "GITHUB_TOKEN=${GITHUB_TOKEN}\nGITHUB_USERNAME=${GITHUB_USERNAME}" > .env
	# uncomment for a clean run
	# docker compose -f docker-compose-test.yml down -v
	mkdir -p ${CI_PROJECT_DIR}/selenium/screenshots
	docker compose -f docker-compose-test.yml run -v ${CI_PROJECT_DIR}/selenium/screenshots:/opt/selenium selenium_ui_tests
