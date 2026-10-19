#!/bin/bash

set -euo pipefail

# Nettoyage du flag d'état à chaque arrêt
rm -f /tmp/.dockerd-ready

# 📌 List of PIDs of background processes
bg_pids=()

# 🧹 Function called at the end of the script to kill background processes
kill_jobs() {
    rm -f /tmp/.dockerd-ready

    echo "Cleaning up Docker services..."

    local pid

    for pid in "${bg_pids[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
        fi
    done

    for pid in "${bg_pids[@]}"; do
        wait "$pid" 2>/dev/null || true
    done
}

# 🚨 Register cleanup function to run on script exit
trap kill_jobs EXIT

get_upstream_dns() {
    local line server
    local -a dns=()

    while IFS= read -r line; do
        if [[ "$line" =~ ^#\ ExtServers:\ \[(.*)\]$ ]]; then
            for server in ${BASH_REMATCH[1]}; do
                [[ "$server" == "127.0.0.11" ]] && continue
                dns+=("$server")
            done
        fi
    done < /etc/resolv.conf

    if (( ${#dns[@]} > 0 )); then
        printf '%s\n' "${dns[@]}"
    fi
}

LOCAL_USER="$(id -un)"

if ! grep -q "^${LOCAL_USER}:" /etc/subuid; then
    echo "${LOCAL_USER}:100000:65536" | sudo tee -a /etc/subuid
fi

if ! grep -q "^${LOCAL_USER}:" /etc/subgid; then
    echo "${LOCAL_USER}:100000:65536" | sudo tee -a /etc/subgid
fi

export LOCAL_USER_ID=$(id -u)
# Set inotify watches limit
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p
# Set inotify watches limit for rootless dockerd
echo fs.inotify.max_user_watches=524288 | sudo tee -a /run/user/$LOCAL_USER_ID/sysctl.conf
sudo sysctl -p /run/user/$LOCAL_USER_ID/sysctl.conf

DNS_ARGS=()

while read -r server; do
    DNS_ARGS+=(--dns="$server")
done < <(get_upstream_dns)


echo "Starting dockerd with arguments: ${DNS_ARGS[@]}"

dockerd-entrypoint.sh "${DNS_ARGS[@]}" &
dockerd_pid="$!"

export DOCKER_HOST="unix:///run/user/$(id -u)/docker.sock"

echo "Waiting for Docker daemon (PID=$dockerd_pid)..."

DOCKER_START_TIMEOUT="${DOCKER_START_TIMEOUT:-120}"
start_time=$SECONDS

until docker info >/dev/null 2>&1; do

    # Vérifier si le processus de lancement est toujours actif
    if ! kill -0 "$dockerd_pid" 2>/dev/null; then
        echo "ERROR: Docker daemon process exited unexpectedly"

        wait "$dockerd_pid" || true

        exit 1
    fi

    # Timeout
    if (( SECONDS - start_time >= DOCKER_START_TIMEOUT )); then
        echo "ERROR: Docker daemon startup timeout after ${DOCKER_START_TIMEOUT}s"

        kill "$dockerd_pid" 2>/dev/null || true
        wait "$dockerd_pid" 2>/dev/null || true

        exit 1
    fi

    echo "Waiting for Docker daemon..."
    sleep 1
done

echo "Docker daemon is ready"
docker info

mkdir -p ${HOME}/.docker/run
ln -sfn /run/user/$LOCAL_USER_ID/docker.sock ${HOME}/.docker/run/docker.sock

# Create a ready flag file for healthchecks and other services to know when the dockerd is ready to exit
echo "{\"status\":\"ready\",\"ts\":$(date +%s)}" > /tmp/.dockerd-ready

wait "$dockerd_pid"