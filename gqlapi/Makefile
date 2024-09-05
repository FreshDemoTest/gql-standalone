.PHONY: test

run_dev_server:
	source .env && poetry run api-server

run_supplier_delegation:
	source .env && poetry run python -m gqlapi.scripts.cx.run_supplier_delegation_mode $(ARGS)

install_all_packages:
	poetry install

install_development_packages:
	poetry install --with dev

lock_dependencies:
	poetry lock

test_all:
	- source .env && poetry run pytest -vs tests/unit/
	- source .env && poetry run pytest -vs tests/integration/

test_unit:
	- source .env && poetry run pytest -vs tests/unit/

test_integration:
	- source .env && poetry run pytest -vs tests/integration/