#!/bin/bash
set -euo pipefail


container_docker_install_success=false
# 🧹 Function called at the end of the script to check for success
check_success() {
    if [ $container_docker_install_success = true ]; then
        echo "♻️ Docker Debian container installed successfully."
    else
        echo "❌ Docker Debian container installation failed."
    fi
}

# 🚨 Register cleanup function to run on script exit
trap check_success EXIT
# Local Container Cache
container_cache=${CONTAINER_CACHE:-${LOCAL_DIR:-${PWD}}/.containers/docker}
mkdir -p $container_cache

# local docker rootless cache 
LOCAL_DOCKERD_ROOTLESS_CACHE=${HOME}/.local/share/docker
mkdir -p $container_cache/dockerd
mkdir -p ${HOME}/.local/share/
ln -sfn $container_cache/dockerd $LOCAL_DOCKERD_ROOTLESS_CACHE

mkdir -p ${HOME}/.bashrc.d

# set "dockerSocket" to the default "--host" *unix socket* value (for both standard or rootless)
uid="$(id -u)"
if [ "$uid" = '0' ]; then
    dockerSocket='unix:///var/run/docker.sock'
else
    # if we're not root, we must be trying to run rootless
    : "${XDG_RUNTIME_DIR:=/run/user/$uid}"
    dockerSocket="unix://$XDG_RUNTIME_DIR/docker.sock"
fi
case "${DOCKER_HOST:-}" in
    unix://*)
        dockerSocket="$DOCKER_HOST"
        ;;
esac

cat <<<EOF > ~/.bashrc.d/21-dockerd.sh
export DOCKER_HOST=${dockerSocket}
export DOCKER_RUNTIME=dind
EOF

. ~/.bashrc.d/21-dockerd.sh

container_docker_install_success=true