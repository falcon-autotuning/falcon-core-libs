#!/usr/bin/env bash
set -euo pipefail

# Export your gh-authenticated token into the environment and start the dev container.
# Do NOT commit this file or the token into version control.
export GH_TOKEN="$(gh auth token)"
# Check if the dev service is running
if ! docker compose ps --services --filter "status=running" | grep -q "^dev$"; then
    echo "Starting dev container (background)..."
    docker compose up -d dev
fi

# Wait for the user 'daniel' to be available (container initialization)
# The entrypoint script creates the user, which might take a moment.
MAX_RETRIES=30
count=0
while ! docker compose exec dev id -u daniel >/dev/null 2>&1; do
    if [ $count -eq $MAX_RETRIES ]; then
        echo "Error: Timed out waiting for user 'daniel' to be created in the container."
        echo "Check container logs with: docker compose logs dev"
        exit 1
    fi
    echo "Waiting for container initialization (user 'daniel')... $((count+1))/$MAX_RETRIES"
    sleep 2
    count=$((count+1))
done

# Execute the command inside the running container as user 'daniel'
# We use 'bash -c' to ensure arguments are parsed correctly
docker compose exec --user daniel dev bash -c "export PATH=/home/daniel/.local/bin:\$PATH; $*"
