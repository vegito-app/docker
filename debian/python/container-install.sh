#!/bin/bash

set -euo pipefail

caches_refresh_success=false
# 🧹 Function called at the end of the script to check for success
check_success() {
    if [ $caches_refresh_success = true ]; then
        echo "♻️ Python container install successful."
    else
        echo "❌ Python container install failed."
    fi
}

# 🚨 Register cleanup function to run on script exit
trap check_success EXIT

CONTAINER_CACHE=${LOCAL_WORKSPACE}/.containers/python
mkdir -p $CONTAINER_CACHE

# Local Container Cache
local_container_cache=${CONTAINER_CACHE:-${LOCAL_WORKSPACE:-${PWD}}/.containers/python}
mkdir -p $local_container_cache

# Python/pip cache
PIP_CACHE_DIR=${HOME}/.cache/pip
[ -d $PIP_CACHE_DIR ] && mv $PIP_CACHE_DIR ${PIP_CACHE_DIR}_back || true
mkdir -p ${local_container_cache}/pip ${PIP_CACHE_DIR}
ln -sfn ${local_container_cache}/pip $PIP_CACHE_DIR

caches_refresh_success=true