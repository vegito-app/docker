#!/bin/bash

set -euo pipefail

# Nettoyage du flag d'état à chaque arrêt
rm -f /tmp/.dockerd-ready

# 📌 List of PIDs of background processes
bg_pids=()

# 🧹 Function called at the end of the script to kill background processes
kill_jobs() {
  rm -f /tmp/.dockerd-ready
  echo "🧼 Cleaning up Docker services..."
  for pid in "${bg_pids[@]}"; do
    kill "$pid" || true
    wait "$pid" 2>/dev/null || true
  done
}

# 🚨 Register cleanup function to run on script exit
trap kill_jobs EXIT

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

mapfile -t DNS_SERVERS < <(awk '/^nameserver/ { print $2 }' /etc/resolv.conf)

DOCKERD_ARGS=()
for dns in "${DNS_SERVERS[@]}"; do
    DOCKERD_ARGS+=(--dns="$dns")
done

echo "Starting dockerd with arguments: ${DOCKERD_ARGS[@]}"

dockerd-entrypoint.sh "${DOCKERD_ARGS[@]}" &
dockerd_pid="$!"

export LOCAL_USER_ID=$(id -u)
export DOCKER_HOST=unix:///run/user/$LOCAL_USER_ID/docker.sock

until docker info >/dev/null 2>&1; do echo waiting dockerd startup ; sleep 1 ; done

docker info

mkdir -p ${HOME}/.docker/run
ln -sfn /run/user/$LOCAL_USER_ID/docker.sock ${HOME}/.docker/run/docker.sock

# Create a ready flag file for healthchecks and other services to know when the dockerd is ready to exit
echo "{\"status\":\"ready\",\"ts\":$(date +%s)}" > /tmp/.dockerd-ready

wait "$dockerd_pid"