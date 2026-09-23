#!/bin/bash

set -euo pipefail

# 🚀 Setup background services

if [ "${DOCKER_RUNTIME:-host}" = "dind" ]; then
    echo "🐳 Starting Docker DIND Rootless"
    /usr/local/bin/debian-dind-start.sh &
    bg_pids+=("$!")

    # Forward Docker DIND Rootless socket
    socat TCP-LISTEN:23766,fork UNIX-CONNECT:/run/user/1000/docker/docker.sock > /tmp/socat-docker-23766.log 2>&1 &
    bg_pids+=("$!")

else
    echo "🐳 Docker DIND Rootless not started."

    # Forwarding host docker socket
    # Listening docker socket at local TCP 2375 will allow vscode to forward it to your remote editor.
    # (localhost:2375 will be used if it is available on your editor machine or another one will be tried by vscode).
    # This is working both on Github Codespaces and on local vscode with the "Remote - Containers" extension.
    # Port forwarding is automatically done by vscode when a process is listening.
    # This is secure as the socket is only accessible from inside the container and you have an ssh or vscode remote session.
    socat TCP-LISTEN:2375,fork UNIX-CONNECT:/var/run/docker.sock > /tmp/socat-docker-2375.log 2>&1 &
    bg_pids+=("$!")
fi


# Pay attention to use a path that is mounted inside the container. Because you want to edit files from your host machine.
# This is typically a workspace folder mounted inside the container.
# By default, we are using the current working directory (PWD) as the workspace folder.
# You can override the default location by setting the LOCAL_WORKSPACE environment variable.
# Example: export LOCAL_WORKSPACE=/path/to/your/local/workspace
current_workspace=$PWD

LOCAL_WORKSPACE=${LOCAL_WORKSPACE:-/workspaces/vegito-app/local}
if [ "$current_workspace" != "$LOCAL_WORKSPACE" ] ; then
    sudo ln -sfn $current_workspace $LOCAL_WORKSPACE 2>&1 || true
    echo "Linked current workspace $current_workspace to $LOCAL_WORKSPACE"
fi

forward_firebase_port() {
    local port="$1"
    local log_file="/tmp/socat-firebase-emulators-${port}.log"

    echo "🔥 Firebase Emulator: 127.0.0.1:${port} -> firebase-emulators:${port}"

    socat \
        "TCP-LISTEN:${port},bind=127.0.0.1,fork,reuseaddr" \
        "TCP:firebase-emulators:${port}" \
        > "${log_file}" 2>&1 &
    bg_pids+=("$!")
}

# Firebase CLI internal services bind to loopback only.
# firebase-emulators re-exposes them on dedicated bridge ports so that
# containers running the Emulator UI browser can recreate them locally.
forward_firebase_internal_port() {
    local local_port="$1"
    local remote_port="$2"
    local log_file="/tmp/socat-firebase-emulators-${remote_port}.log"

    echo "🔥 Firebase Emulator UI: 127.0.0.1:${local_port} -> firebase-emulators:${remote_port}"

    socat \
        "TCP-LISTEN:${local_port},bind=127.0.0.1,fork,reuseaddr" \
        "TCP:firebase-emulators:${remote_port}" \
        > "${log_file}" 2>&1 &
    bg_pids+=("$!")
}

# Ports Firebase normaux : même port des deux côtés
forward_firebase_port 9000
forward_firebase_port 9099
forward_firebase_port 9150
forward_firebase_port 9199
forward_firebase_port 8085
forward_firebase_port 8090
forward_firebase_port 5001
forward_firebase_port 4000

# Ports internes UI : port de transport différent
forward_firebase_internal_port 9499 9599
forward_firebase_internal_port 9299 9399
forward_firebase_internal_port 4500 4501
forward_firebase_internal_port 4400 4401

if [ -f /usr/local/bin/desktop-x-start.sh ]; then
    echo "🖥️ X Desktop starting..."
    /usr/local/bin/desktop-x-start.sh
else
    echo "🖥️ X Desktop not started."
    sleep infinity
fi