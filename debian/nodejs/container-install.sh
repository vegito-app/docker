#!/bin/bash

set -uo pipefail
trap "echo Exited with code $?." EXIT

# Use a local directory to persist container caches and configurations across container rebuilds.
# You can override the default location by setting the CONTAINER_CACHE environment variable.
# Example: export CONTAINER_CACHE=/path/to/your/local/cache
# If CONTAINER_CACHE is not set, it will default to $LOCAL_WORKSPACE/.containers
local_container_cache=${CONTAINER_CACHE:-${LOCAL_WORKSPACE:-${PWD}}/.containers/dev}
mkdir -p $local_container_cache

# NPM persistence
# This allows you to persist your npm configuration across container rebuilds.
NPM_DIR=${HOME}/.npm
[ -d $NPM_DIR ] && mv $NPM_DIR ${NPM_DIR}_back
mkdir -p ${local_container_cache}/npm
ln -sf ${local_container_cache}/npm $NPM_DIR
