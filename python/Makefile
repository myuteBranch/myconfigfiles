TEST_PATH = src/
.DEFAULT_GOAL = help
help:
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m %-30s\033[0m %s\n", $$1, $$2}'

lint: ## 'make lint' will run linting for project
	@echo "Running linter"
	flake8 ${TEST_PATH}

test: ## 'make test' will run unittests for project
	@echo "Running Unittests"
	pytest tests/

coverage: ## 'make coverage' will run code coverage for project
	@echo "Running Unittests and Coverage"
	pytest tests/ --cov-config=.coveragerc --cov ${TEST_PATH} --cov-report html --cov-report term-missing

clean:
	rm -rf ./.pytest_cache ./htmlcov ./.coverage