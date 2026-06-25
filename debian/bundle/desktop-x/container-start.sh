#!/bin/bash

set -euo pipefail

# 📌 List of PIDs of background processes
bg_pids=()

# 🧹 Function called at the end of the script to kill background processes
kill_jobs() {
    echo "🧼 Cleaning up Desktop X services..."
    for pid in "${bg_pids[@]}"; do
        kill "$pid" || true
        wait "$pid" 2>/dev/null || true
    done
}

# 🚨 Register cleanup function to run on script exit
trap kill_jobs EXIT


ENABLE_AUDIO="${ENABLE_AUDIO:-0}"
if [ "$ENABLE_AUDIO" = "1" ]; then
    # 🔊 Start a persistent PulseAudio daemon for the whole container session
    pulseaudio \
        --daemonize=no \
        --system=false \
        --disallow-exit \
        --exit-idle-time=-1 \
        --log-target=stderr &
    bg_pids+=("$!")

    for i in $(seq 1 10); do
        if pactl info >/dev/null 2>&1; then
            echo "🔊 PulseAudio ready"
            break
        fi
        echo "⏳ Waiting for PulseAudio..."
        sleep 1
    done

    # 🔍 Debug PulseAudio availability
    pactl info
fi

if [ ${VEGITO_DOCKER_DEBIAN_DESKTOP_X_CONTAINER_DISPLAY_START:-"true"} = "true" ]; then
    echo "✅ VEGITO_DOCKER_DEBIAN_DESKTOP_X_CONTAINER_DISPLAY_START is set to true"
    container-display-start.sh
fi
 
