#!/bin/bash

set -uo pipefail
trap "echo Exited with code $?." EXIT

# Use a local directory to persist container caches and configurations across container rebuilds.
# You can override the default location by setting the OBS_CONTAINER_CACHE environment variable.
# Example: export OBS_CONTAINER_CACHE=/path/to/your/local/cache
# If OBS_CONTAINER_CACHE is not set, it will default to $LOCAL_WORKSPACE/.containers
local_container_cache=${OBS_CONTAINER_CACHE:-${LOCAL_WORKSPACE:-${PWD}}/.containers/obs}
mkdir -p $local_container_cache

