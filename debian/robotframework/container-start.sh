#!/bin/bash

set -euo pipefail

trap "echo Exited with code $?." EXIT

kill_jobs() {
    echo "Killing background jobs"
    for pid in "$${bg_pids[@]}"; do
        kill "$$pid"
        wait "$$pid" 2>/dev/null
    done
}

trap kill_jobs EXIT

mkdir -p ${LOCAL_ROBOTFRAMEWORK_TESTS_DIR}

cd ${LOCAL_ROBOTFRAMEWORK_TESTS_DIR} && python3 -m http.server 8088 &
bg_pids+=($!)

sleep infinity
