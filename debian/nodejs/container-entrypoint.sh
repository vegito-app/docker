#!/bin/bash

set -euo pipefail

# 🐧 Setup Debian
# Project container installation script to setup persistent configurations and caches.
# If NODEJS_CONTAINER_INSTALL is set to "true", run the local-container-install.sh script
# to install the necessary configurations and caches.
# This is useful for local development environments where you want to keep your settings across container rebuilds.
# You can set this variable in your devcontainer.json or in your environment before starting the container.
# Example: export NODEJS_CONTAINER_INSTALL=true
if [ "${NODEJS_CONTAINER_INSTALL:-true}" = true ]; then
    nodejs-container-install.sh
fi


# Run the command
exec "$@"