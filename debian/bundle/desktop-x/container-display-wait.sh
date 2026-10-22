#!/bin/bash

set -euo pipefail

for i in $(seq 1 300); do
    if [ -f /tmp/.xdisplay-ready ]; then
        break
    fi
    echo "⏳ Waiting for X display..."
    sleep 1
done

if [ ! -f /tmp/.xdisplay-ready ]; then
    echo "❌ Display not ready"
    exit 1
fi

echo "✅ Display is ready"