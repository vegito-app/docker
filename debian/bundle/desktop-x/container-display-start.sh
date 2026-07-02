#!/bin/bash

set -euo pipefail

# -------------------------------------------------------------------
# GPU mode auto-detection
# -------------------------------------------------------------------

if command -v nvidia-smi >/dev/null 2>&1 &&
    nvidia-smi >/dev/null 2>&1; then
    if [ -z "${VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE:-}" ]; then
        echo "✅ NVIDIA GPU acceleration detected -> using Wayland GPU mode"
        export VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE="wayland"
    fi
fi

if [ -z "${VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE:-}" ]; then
    export VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE="swiftshader_indirect"
    echo "ℹ️ No GPU acceleration detected -> using SwiftShader fallback"
fi
export DISPLAY="${DISPLAY:-:1}"

case "${VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE}" in
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

    "swiftshader_indirect" | "guest")
        echo "🖥️ Starting SwiftShader software rendering mode"
        desktop-x-display-xvfb.sh
        ;;

    *)
        echo "⚠️ Unknown VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE='${VEGITO_DOCKER_DEBIAN_DESKTOP_X_GPU_MODE}', falling back to SwiftShader"
        desktop-x-display-xvfb.sh
        ;;
esac
 
