TEST_PATH = ./...
CONFIG_PATH ?= example.com/repoorg/reponame
BINARY_NAME ?= binaryname
VERSION ?= 0.0.0
BUILD_DIR := bin
GIT_REV_PARSE := $(shell git rev-parse HEAD)
BRANCH_NAME := $(shell git rev-parse --abbrev-ref HEAD)
COMMIT_ID := $(if ${GIT_REV_PARSE},${GIT_REV_PARSE},unknown)
DATECMD := date$(if $(findstring Windows,$(OS)),.exe)
BUILD_TIMESTAMP := $(shell ${DATECMD} +%Y-%m-%dT%H:%m:%S%z)
.DEFAULT_GOAL = help
help:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m %-30s\033[0m %s\n", $$1, $$2}'

lint: ## 'make lint' will run linting for project
	@echo "Running linter"
	gofmt -d .

test: ## 'make test' will run unitests for project
	@echo "Running Unittests"
	go test -v ${TEST_PATH} -coverprofile=coverage.out -json > test-report.json

coverage: ## 'make coverage' will run code coverage for project
	@echo "Running Unittests and Coverage"
	mkdir -p cov/
	go test ${TEST_PATH} -coverprofile=cov/coverage.out
	go tool cover -html=cov/coverage.out -o /cov/coverage.html

build:
	@echo "Compiling for every OS and Platform"
	@make --no-print-directory  build-platform GOOS=windows GOARCH=386 CGO_ENABLED=0
	@make --no-print-directory  build-platform GOOS=windows GOARCH=amd64 CGO_ENABLED=0
	@make --no-print-directory  build-platform GOOS=linux GOARCH=amd64 CGO_ENABLED=0
	@make --no-print-directory  build-platform GOOS=linux GOARCH=arm64 CGO_ENABLED=0
	@make --no-print-directory  build-platform GOOS=darwin GOARCH=arm64 CGO_ENABLED=0
	@make --no-print-directory  build-platform GOOS=darwin GOARCH=amd64 CGO_ENABLED=0

build-platform:
	@echo "Building ${GOOS}-${GOARCH}"
	$(eval BINARY := ${BINARY_NAME}$(if $(findstring windows,$(GOOS)),.exe))
	go build -o ${BUILD_DIR}/${GOOS}-${GOARCH}/${BINARY} \
		-ldflags=all="-X ${CONFIG_PATH}.Version=${Version} -X ${CONFIG_PATH}.GitCommit=${COMMIT_ID} -X ${CONFIG_PATH}.BuiltOn=${BUILD_TIMESTAMP}"

clean:
	rm -rf ${BUILD_DIR}
	go clean -modcache