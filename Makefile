PYTHON = python3

# Run non-lint checks. (pyre-check for static typing)
# Run linters. (flake, pyfmt, isort)
# FILES = $(shell find app tests -name '*.py')
lint:
	./tools/lint/errors-and-undefined
	./tools/lint/pep8-syntax
	
# # Run test on all folders
.PHONY: test
test:
	./tools/test/pytest

.PHONY: local-test
local-test:
	. .env && ./tools/test/pytest


# isort:
# 	# Sort imports in all `*.py` files.
# 	$(foreach dir,$(SOURCE),cd $(dir); $(CMD_ISORT))

# isort_check:
# 	# Checks for correctly sorted imports in all `*.py` files.
# 	$(foreach dir,$(SOURCE),cd $(dir); $(CMD_PYLAMA_ISORT_CHECK))

all: $(BUILD_DIR)/*.whl

# Build project wheel
PROJECTS=$(shell find . -type d -not -path './.git/*' -not -path '*/domain/*' -not -path '*/lib/*' -not -path '*/.venv/*' | grep projects | sed -e 's/"//g' | cut -d/ -f4 | grep -v "^$$" | sort --unique)	
.PHONY: $(PROJECTS)
$(PROJECTS):
	@echo $(PROJECTS)
	./tools/build.sh $@