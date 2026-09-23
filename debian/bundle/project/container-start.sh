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

forward_port() {
    local local_port="$1"
    local remote_host="$2"
    local remote_port="${3:-$local_port}"

    echo "🔀 127.0.0.1:${local_port} -> ${remote_host}:${remote_port}"

    socat \
        "TCP-LISTEN:${local_port},bind=127.0.0.1,fork,reuseaddr" \
        "TCP:${remote_host}:${remote_port}" \
        > "/tmp/socat-${remote_host}-${remote_port}.log" 2>&1 &

    bg_pids+=("$!")
}

# Firebase emulators
forward_port 4000 firebase-emulators
forward_port 5001 firebase-emulators
forward_port 8085 firebase-emulators
forward_port 8090 firebase-emulators
forward_port 9000 firebase-emulators
forward_port 9099 firebase-emulators
forward_port 9150 firebase-emulators
forward_port 9199 firebase-emulators

# Firebase CLI internal ports re-exposed by firebase-emulators
forward_port 4400 firebase-emulators 4401
forward_port 4500 firebase-emulators 4501
forward_port 9299 firebase-emulators 9399
forward_port 9499 firebase-emulators 9599

if [ -f /usr/local/bin/desktop-x-start.sh ]; then
    echo "🖥️ X Desktop starting..."
    /usr/local/bin/desktop-x-start.sh
else
    echo "🖥️ X Desktop not started."
    sleep infinity
fi