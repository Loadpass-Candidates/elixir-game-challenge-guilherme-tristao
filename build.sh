#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

MIX_ENV=prod mix assets.deploy

mix phx.gen.release

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite
