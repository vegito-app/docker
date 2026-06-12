#!/bin/sh

set -euo pipefail

trap "echo Exited with code $?." EXIT

# 🐧 Setup Debian
debian-entrypoint.sh echo "✅ Debian setup complete."

if [ "${VEGITO_DOCKER_DEBIAN_PYTHON_CONTAINER_INSTALL:-true}" = "true" ]; then
    python-container-install.sh
fi

exec "$@"