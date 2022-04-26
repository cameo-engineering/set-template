#!/usr/bin/env just --justfile

set dotenv-load
set export
set positional-arguments

MNEMONIC := env_var_or_default("MNEMONIC", "catch address error receive abstract virtual memory private return public false library")
INFURA_PROJECT_ID := env_var_or_default("INFURA_PROJECT_ID", "84842078b09946638c03157f83405213")
ETHERSCAN_API_KEY := env_var_or_default("ETHERSCAN_API_KEY", "9D13ZE7XSBTJ94N9BNJ2MA33VMAY2YPIRB")
COIN_MARKET_CAP_API_KEY := env_var_or_default("COIN_MARKET_CAP_API_KEY", "d25b5576-a4ee-41be-bb2b-aca2ba3ae5d8")

alias b := build
alias fmt := format
alias l:= lint
alias rb := rebuild
alias sz := sizes
alias t := test

default:
  just --list

@analyze:
  slither ./

# Build the project's smart contracts
@build *FLAGS:
  forge build {{FLAGS}}

# Remove the build artifacts and cache directories
@clean:
  forge clean

@format:
  prettier --config ./.prettierrc.toml --write "./**/*.{json,md,sol,yaml,yml}"

@lint:
  solhint --config ./.solhint.json --max-warnings 0 --fix  "./src/**/*.sol"

# Rebuild the project's smart contracts
@rebuild *FLAGS: (build FLAGS "--force")

# Start a two-way connection between the project and Remix IDE
@remixd:
  remixd --shared-folder ./ --remix-ide https://remix.ethereum.org

# Print compiled contract sizes
@sizes: (rebuild "--sizes")

# Run the project's tests
@test *FLAGS:
  forge test {{FLAGS}}

# yarn prettier --check --config ./.prettierrc  "./**/*.{js,json,md,sol,ts,yml}"
