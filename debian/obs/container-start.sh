#!/bin/bash

set -euo pipefail

# Nettoyage du flag d'état à chaque arrêt
rm -f /tmp/.obs-ready

# 📌 List of PIDs of background processes
bg_pids=()
obs_pid=

# 🧹 Function called at the end of the script to kill background processes
kill_jobs() {
    rm -f /tmp/.obs-ready
    echo "🧼 Cleaning up OBS background..."
    for pid in "${bg_pids[@]}"; do
        kill "$pid" || true
        wait "$pid" 2>/dev/null || true
    done
}

# 🚨 Register cleanup function to run on script exit
trap kill_jobs EXIT

# 🚀 Start background services

if [ -f /usr/local/bin/desktop-x-start.sh ]; then
    echo "🖥️ X Desktop starting..."
    /usr/local/bin/desktop-x-start.sh &
    bg_pids+=("$!")
else
    echo "🖥️ X Desktop not started."
fi

obs &
obs_pid=$!

# Création d'un flag indiquant que Xpra est prêt
echo "{\"status\":\"ready\",\"ts\":$(date +%s)}" > /tmp/.obs-ready

echo "✅ OBS started successfully."

wait $obs_pid