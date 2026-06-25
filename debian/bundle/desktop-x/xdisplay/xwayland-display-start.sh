#!/bin/bash

set -euo pipefail

# Nettoyage du flag d'état à chaque arrêt
rm -f /tmp/.xdisplay-ready
# 📌 List of PIDs of background processes
bg_pids=()

# 🖥️ Default parameters
default_depth="24"
default_display_number=":1"
default_framerate="60"
default_resolution="1920x1080"
default_wayland_socket="wayland-1"

resolution="${DISPLAY_RESOLUTION:-$default_resolution}"
depth="${DISPLAY_DEPTH:-$default_depth}"
display="${DISPLAY:-$default_display_number}"
framerate="${DISPLAY_FRAMERATE:-$default_framerate}"
wayland_socket="${WAYLAND_SOCKET:-$default_wayland_socket}"

# 🧹 Function called at the end of the script to kill background processes
kill_jobs() {
    rm -f /tmp/.xdisplay-ready
    echo "Desktop X services..."

    for pid in "${bg_pids[@]}"; do
        kill "$pid" 2>/dev/null || true
        wait "$pid" 2>/dev/null || true
    done

    pkill -f -9 "Xwayland $display" || true
    pkill -f "weston.*${WAYLAND_DISPLAY_NAME}" || true
    rm -rf /tmp/.X11-unix/X${display#*:}
    rm -rf /tmp/.X${display#*:}-lock
}

# 🚨 Register cleanup function to run on script exit
trap kill_jobs EXIT
# Keep exactly one Wayland socket name source of truth:
# - default: wayland-1
# - override: existing WAYLAND_DISPLAY from docker-compose/env
WAYLAND_DISPLAY_NAME="${WAYLAND_DISPLAY:-${WAYLAND_DISPLAY_NAME:-$wayland_socket}}"
DISPLAY_RESOLUTION=${DISPLAY_RESOLUTION:-$default_resolution}

# -------------------------------------------------------------------
# Weston startup
# -------------------------------------------------------------------

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY_NAME}"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY_NAME}"

mkdir -p /tmp/.X11-unix

echo "🚀 Starting Weston headless GPU compositor..."

cat >/tmp/weston.ini <<EOF
[core]
backend=headless-backend.so
idle-time=0

[shell]
panel-position=none
locking=false
EOF

# 🖥️ Resolution personnalisé
# 🔧 Extraction robuste de la largeur et hauteur
width="${resolution%x*}"    # Supprime 'x*' à partir de la fin
height="${resolution#*x}"   # Supprime '*x' depuis le début

# 🚀 Starting Weston compositor with NVIDIA OpenGL
unset EGL_PLATFORM
unset LIBGL_ALWAYS_SOFTWARE

echo "🚀 Starting Weston compositor with NVIDIA OpenGL..."
weston \
  --backend=headless-backend.so \
  --use-gl \
  --socket="${WAYLAND_DISPLAY_NAME}" \
  --config=/tmp/weston.ini \
  --width="${width}" \
  --height="${height}" \
    > /tmp/weston.log 2>&1 &
weston_pid=$!
bg_pids+=("${weston_pid}")

timeout_weston=60

for i in $(seq 1 ${timeout_weston}); do
    if [ -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
        break
    fi

    echo "⏳ Waiting for Weston Wayland socket..."
    sleep 1
done

if [ ! -S "${XDG_RUNTIME_DIR}/${WAYLAND_DISPLAY}" ]; then
    echo "❌ Weston socket not available."
    echo "----- WESTON LOG -----"
    cat /tmp/weston.log || true
    exit 1
fi

echo "✅ Weston started successfully."

# -------------------------------------------------------------------
# Manual XWayland startup
# -------------------------------------------------------------------

export DISPLAY="${display}"

rm -f /tmp/.X11-unix/X${display#*:}
rm -f /tmp/.X${display#*:}-lock

echo "🚀 Starting manual XWayland EGLStream server..."

# 🖥️ XWayland

Xwayland "${display}" \
    +extension GLX \
    +extension RANDR \
    +extension RENDER \
    +extension COMPOSITE \
    > /tmp/xwayland.log 2>&1 &

xwayland_pid=$!
bg_pids+=("${xwayland_pid}")

until [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; do
    echo "⏳ Waiting for Weston socket..."
    sleep 1
done

until glxinfo -B >/dev/null 2>&1; do
    echo "⏳ Waiting for XWayland GLX..."
    sleep 1
done
echo "🔍 OpenGL renderer"
glxinfo -B | grep -E "OpenGL vendor|OpenGL renderer|OpenGL version" || echo "⚠️ OpenGL info not available"

echo "✅ Weston/XWayland started successfully on display ${display}."

if command -v setxkbmap >/dev/null 2>&1; then
    echo "🔍 XWayland keyboard map"
    setxkbmap -display "${DISPLAY}" -query || true
fi

if command -v xkbcomp >/dev/null 2>&1; then
    echo "🔍 XWayland effective XKB symbols"
    xkbcomp -xkb "${DISPLAY}" - 2>/dev/null | grep -m1 'xkb_symbols' || true
fi


# -------------------------------------------------------------------
# GPU validation
# -------------------------------------------------------------------

if command -v glxinfo >/dev/null 2>&1; then
    echo "🔍 XWayland GLX capabilities"
    glxinfo -B || true
fi

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY_NAME}"
export WAYLAND_DEBUG=0

WAYVNC_PORT=${WAYVNC_PORT:-5901}

if command -v weston-terminal >/dev/null 2>&1; then
    echo "🖥️ Launching weston-terminal..."
    weston-terminal > /tmp/weston-terminal.log 2>&1 &
    bg_pids+=("$!")
elif command -v foot >/dev/null 2>&1; then
    echo "🖥️ Launching foot terminal..."
    foot > /tmp/foot.log 2>&1 &
    bg_pids+=("$!")
else
    echo "⚠️ No Wayland terminal found (weston-terminal or foot missing)."
fi

echo "🔍 Weston GPU capabilities"

grep -E "GL renderer|GL vendor|GL version" /tmp/weston.log || true

echo "🖥️ Weston headless GPU session ready"
echo "📺 XWayland display available on DISPLAY=${display}"
echo "✅ GPU compositor active"
echo "ℹ️ Launch Wayland-native applications inside this session"

DISPLAY_MODE="${DISPLAY_MODE:-xpra}"

if [ "$DISPLAY_MODE" = "xpra" ]; then

    echo "🌀 Starting Xpra on ${display}"
    desktop-x-xpra-start.sh &
    display_pid="$!"

elif [ "$DISPLAY_MODE" = "vnc" ]; then

    vnc-start.sh &
    display_pid="$!"
    
else
    echo "⚠️ Invalid display mode. Please choose 'xpra' or 'vnc'."
fi

echo "GBM_BACKEND=${GBM_BACKEND:-unset}"
echo "__GLX_VENDOR_LIBRARY_NAME=${__GLX_VENDOR_LIBRARY_NAME:-unset}"
echo "__EGL_VENDOR_LIBRARY_FILENAMES=${__EGL_VENDOR_LIBRARY_FILENAMES:-unset}"

glxinfo -B | grep -Ei "vendor|renderer"
# Création d'un flag indiquant que tout le display est prêt
echo "{\"status\":\"ready\",\"ts\":$(date +%s)}" > /tmp/.xdisplay-ready

wait "$display_pid" || true

echo "🛑 Session ended."
