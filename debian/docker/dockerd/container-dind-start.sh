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

get_upstream_dns() {
    local dns=()

    while read -r line; do
        if [[ "$line" =~ ^#\ ExtServers:\ \[(.*)\]$ ]]; then
            for server in ${BASH_REMATCH[1]}; do
              # Discard the default Docker DNS server if present
              [[ "$dns" == "127.0.0.11" ]] && continue
              dns+=("$server")
            done
        fi
    done < /etc/resolv.conf

    printf '%s\n' "${dns[@]}"
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

export LOCAL_USER_ID=$(id -u)
export DOCKER_HOST=unix:///run/user/$LOCAL_USER_ID/docker.sock

until docker info >/dev/null 2>&1; do echo waiting dockerd startup ; sleep 1 ; done

docker info

mkdir -p ${HOME}/.docker/run
ln -sfn /run/user/$LOCAL_USER_ID/docker.sock ${HOME}/.docker/run/docker.sock

# Create a ready flag file for healthchecks and other services to know when the dockerd is ready to exit
echo "{\"status\":\"ready\",\"ts\":$(date +%s)}" > /tmp/.dockerd-ready

wait "$dockerd_pid"