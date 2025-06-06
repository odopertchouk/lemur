NPM_ROOT = ./node_modules
STATIC_DIR = src/lemur/static/app
SHELL=/bin/bash
USER := $(shell whoami)

develop: update-submodules setup-git
	@echo "--> Installing dependencies"
ifeq ($(USER), root)
	@echo "WARNING: It looks like you are installing Lemur as root. This is not generally advised."
	npm install --unsafe-perm
else
	npm install
endif
	pip install setuptools
	# order matters here, base package must install first
	pip install -e .
	pip install -e "file://`pwd`#egg=lemur[dev]"
	pip install -e "file://`pwd`#egg=lemur[tests]"
	node_modules/.bin/gulp build
	node_modules/.bin/gulp package --urlContextPath=$(urlContextPath)
	@echo ""

release:
	@echo "--> Installing dependencies"
ifeq ($(USER), root)
	@echo "WARNING: It looks like you are installing Lemur as root. This is not generally advised."
	npm install --unsafe-perm
else
	npm install
endif
	pip install setuptools
	# order matters here, base package must install first
	pip install -e .
	node_modules/.bin/gulp build
	node_modules/.bin/gulp package --urlContextPath=$(urlContextPath)
	@echo ""

dev-docs:
	pip install -r requirements-docs.txt

reset-db:
	@echo "--> Dropping existing 'lemur' database"
	dropdb lemur || true
	@echo "--> Creating 'lemur' database"
	createdb -E utf-8 lemur
	@echo "--> Enabling pg_trgm extension"
	psql lemur -c "create extension IF NOT EXISTS pg_trgm;"
	@echo "--> Applying migrations"
	cd lemur && lemur db upgrade

setup-git:
	@echo "--> Installing git hooks"
	if [[ -d .git/hooks && -d hooks ]]; then \
		git config branch.autosetuprebase always; \
		cd .git/hooks && ln -sf ../../hooks/* ./; \
	fi
	@echo ""

clean:
	@echo "--> Cleaning static cache"
	${NPM_ROOT}/.bin/gulp clean
	@echo "--> Cleaning pyc files"
	find . -name "*.pyc" -delete
	@echo ""

test: develop lint test-python

testloop: develop
	pip install pytest-xdist
	coverage run --source lemur -m pytest

test-cli:
	@echo "--> Testing CLI"
	rm -rf test_cli
	mkdir test_cli
	cd test_cli && lemur create_config -c ./test.conf > /dev/null
	cd test_cli && lemur -c ./test.conf db upgrade > /dev/null
	cd test_cli && lemur -c ./test.conf help 2>&1 | grep start > /dev/null
	rm -r test_cli
	@echo ""

test-js:
	@echo "--> Running JavaScript tests"
	npm test
	@echo ""

test-python:
	@echo "--> Running Python tests"
	coverage run --source lemur -m pytest
	coverage xml
	@echo ""

lint: lint-python lint-js

lint-python:
	@echo "--> Linting Python files"
	PYFLAKES_NODOCTEST=1 flake8 lemur
	mypy  # scan the directory specified in mypy.ini
	@echo ""

lint-js:
	@echo "--> Linting JavaScript files"
	npm run lint
	@echo ""

coverage: develop
	coverage run --source=lemur -m pytest
	coverage html

publish:
	python setup.py sdist bdist_wheel upload

up-reqs:
ifndef VIRTUAL_ENV
    $(error Please activate virtualenv first)
endif
	@echo "--> Updating Python requirements"
	pip install --upgrade pip
	pip install --upgrade pip-tools
	pip-compile -v --output-file requirements.txt requirements.in -U --no-emit-index-url --resolver=backtracking
	pip-compile -v --output-file requirements-tests.txt requirements-tests.in -U --no-emit-index-url --resolver=backtracking
	pip-compile -v --output-file requirements-dev.txt requirements-dev.in -U --no-emit-index-url --resolver=backtracking
	pip-compile -v --output-file requirements-docs.txt requirements-docs.in -U --no-emit-index-url --resolver=backtracking
	@echo "--> Done updating Python requirements"
	@echo "--> Installing new dependencies"
	pip install -e .
	@echo "--> Done installing new dependencies"
	@echo ""

# Execute with make checkout-pr pr=<pr number>
checkout-pr:
	git fetch upstream pull/$(pr)/head:pr-$(pr)


run-be:
	lemur -c config/lemur.conf.py start -b 0.0.0.0:8000

run-fe:
	node_modules/.bin/gulp serve

.PHONY: develop dev-postgres dev-docs setup-git build clean update-submodules test testloop test-cli test-js test-python lint lint-python lint-js coverage publish release run-be run-fe
