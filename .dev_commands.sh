#!/usr/bin/env bash
set -euo pipefail

# Export your gh-authenticated token into the environment and start the dev container.
# Do NOT commit this file or the token into version control.
export GH_TOKEN="$(gh auth token)"
docker compose run --build --rm dev
