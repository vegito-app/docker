#!/bin/bash

set -euo pipefail

# 📌 List of PIDs of background processes
bg_pids=()

# 🧹 Function called at the end of the script to kill background processes
kill_jobs() {
    rm -f /tmp/.xdisplay-ready
    echo "🧼 Cleaning up VNC services..."
    for pid in "${bg_pids[@]}"; do
        kill "$pid" || true
        wait "$pid" 2>/dev/null || true
    done
}

# 🚨 Register cleanup function to run on script exit
trap kill_jobs EXIT

display="${DEFAULT_DISPLAY:?DEFAULT_DISPLAY is required}"
dpi="${DISPLAY_DPI:?DISPLAY_DPI is required}"

echo "🌀 Starting x11vnc..."
echo "🌀 Starting x11vnc on $DISPLAY..."
x11vnc -display "$DISPLAY" -nopw -noxdamage -shared -forever -repeat &
bg_pids+=("$!")

until nc -z localhost 5900; do
  echo "⏳ Waiting for x11vnc to start on $DISPLAY...";
  sleep 1
done

echo "✅ x11vnc running on $DISPLAY → http://localhost:5900/ 🖥️"

if [ "${#bg_pids[@]}" -gt 0 ]; then
    wait "${bg_pids[@]}"
fi
