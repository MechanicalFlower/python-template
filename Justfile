#!/usr/bin/env -S just --justfile

set dotenv-load := true

export PIP_REQUIRE_VIRTUALENV := "true"

# === Variables ===

# Poetry variables
poetry_version := env_var('POETRY_VERSION')

# === Commands ===

# Display all commands
@default:
    echo "OS: {{ os() }} - ARCH: {{ arch() }}\n"
    just --list

# Install poetry
@install-poetry:
    if [ -z $(command -v poetry) ]; then curl -sSL https://install.python-poetry.org | python3 - --version {{ poetry_version }}; fi

# Install the package
install: install-poetry
    poetry install

# Run formatters
fmt: install
    poetry run pre-commit run -a

# Run tests
test *FILES: install
    poetry run pytest {{ FILES }}
