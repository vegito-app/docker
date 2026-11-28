#!/bin/bash

set -euo pipefail

echo "🧼 Cleaning stale Desktop-X runtime state..."

rm -f /tmp/.xdisplay-ready

export DISPLAY="${DISPLAY:-:1}"

rm -f "/tmp/.X11-unix/X$${DISPLAY#*:}"
rm -f "/tmp/.X$${DISPLAY#*:}-lock"

echo "🧼 Cleaning stale Desktop-X runtime state... Done"

# -------------------------------------------------------------------
# GPU mode auto-detection
# -------------------------------------------------------------------

DISPLAY_MODE="${VEGITO_DOCKER_DEBIAN_DESKTOP_X_DISPLAY_MODE:-auto}"

if [ "$DISPLAY_MODE" = "auto" ]; then
    if command -v nvidia-smi >/dev/null 2>&1 &&
       nvidia-smi >/dev/null 2>&1; then
        DISPLAY_MODE="wayland"
    else
        DISPLAY_MODE="xvfb"
    fi
fi

export VEGITO_DOCKER_DEBIAN_DESKTOP_X_DISPLAY_MODE="$DISPLAY_MODE"
echo "🖥️ Display mode: $DISPLAY

case "${VEGITO_DOCKER_DEBIAN_DESKTOP_X_DISPLAY_MODE}" in
    "host")
        echo "🖥️ Starting host Xorg display mode"
        source /usr/local/bin/desktop-x-nvidia-gl-env.sh 
        desktop-x-display-xorg-host.sh
        ;;

    "wayland")
        echo "🖥️ Starting Wayland GPU display mode"
        source /usr/local/bin/desktop-x-nvidia-gl-env.sh 
        desktop-x-display-wayland.sh
        ;;

    "xvfb" | "guest")
        echo "🖥️ Starting SwiftShader software rendering mode"
        desktop-x-display-xvfb.sh
        ;;

    *)
        echo "⚠️ Unknown VEGITO_DOCKER_DEBIAN_DESKTOP_X_DISPLAY_MODE='${VEGITO_DOCKER_DEBIAN_DESKTOP_X_DISPLAY_MODE}', falling back to SwiftShader"
        desktop-x-display-xvfb.sh
        ;;
esac
 
