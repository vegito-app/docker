#!/bin/bash

set -euo pipefail


caches_refresh_success=false
# 🧹 Function called at the end of the script to check for success
check_success() {
    if [ $caches_refresh_success = true ]; then
        echo "♻️ Robot Framework container install successful."
    else
        echo "❌ Robot Framework container install failed."
    fi
}

# 🚨 Register cleanup function to run on script exit
trap check_success EXIT

# Local Container Cache
local_container_cache=${CONTAINER_CACHE:-${LOCAL_DIR:-${PWD}}/.containers/robotframework}
mkdir -p $local_container_cache

cat << 'EOF' >> ~/.bashrc.d/110-robotframework
alias rf='robot --outputdir ${LOCAL_ROBOTFRAMEWORK_TESTS_DIR} tests/robot'
alias h='htop'
alias i='sudo iftop'
alias ll='ls -lha'
alias l='ls -lh'
alias la='ls -Ah'
alias lla='ls -lhA'
EOF

caches_refresh_success=true