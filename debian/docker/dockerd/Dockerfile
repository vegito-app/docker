FROM docker_dind AS docker-dind

FROM debian
ARG debian_version=bookworm
ARG TARGETPLATFORM

USER root

RUN --mount=type=cache,id=vegito-debian-${debian_version}-${TARGETPLATFORM}-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=vegito-debian-${debian_version}-${TARGETPLATFORM}-apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get -o Acquire::Retries=3 update && apt-get install -y \
    fuse-overlayfs \
    iproute2 \
    iptables \
    slirp4netns \
    uidmap

ARG docker_version

ARG TARGETPLATFORM
RUN \
    set -eu; \
    \
    mkdir -p /run/user && chmod 1777 /run/user; \
    \ 
    case "$TARGETPLATFORM" in \
    "linux/amd64") \
    url="https://download.docker.com/linux/static/stable/x86_64/docker-${docker_version}.tgz"; \
    ;; \
    "linux/arm64") \
    url="https://download.docker.com/linux/static/stable/aarch64/docker-${docker_version}.tgz"; \
    ;; \
    *) echo >&2 "error: unsupported 'docker.tgz' architecture ($TARGETPLATFORM)"; exit 1 ;; \
    esac; \
    wget -O 'docker.tgz' "$url";  \
    \
    tar --extract \
    --file docker.tgz \
    --strip-components 1 \
    --directory /usr/local/bin/ \
    --no-same-owner \
    'docker/docker' \
    'docker/containerd' \
    'docker/dockerd' \
    'docker/runc' \
    'docker/containerd-shim-runc-v2' \
    'docker/ctr' \
    'docker/docker-proxy' \
    'docker/docker-init' \
    ; \
    rm docker.tgz; \
    \
    docker --version; \
    \
    #
    # DOCKER_ROOTLESS
    # 
    \
    case "$TARGETPLATFORM" in \
    "linux/amd64") \
    url="https://download.docker.com/linux/static/test/x86_64/docker-rootless-extras-${docker_version}.tgz"; \
    ;; \
    "linux/arm64") \
    url="https://download.docker.com/linux/static/test/aarch64/docker-rootless-extras-${docker_version}.tgz"; \
    ;; \
    *) echo >&2 "error: unsupported 'rootless.tgz' architecture ($TARGETPLATFORM)"; exit 1 ;; \
    esac; \
    \
    curl -o 'rootless.tgz' -L "${url}"; \
    \
    tar --extract \
    --file rootless.tgz \
    --strip-components 1 \
    --directory /usr/local/bin/ \
    'docker-rootless-extras/rootlesskit' \
    'docker-rootless-extras/vpnkit' \
    ; \
    rm rootless.tgz; \
    \
    rootlesskit --version; \
    vpnkit --version;

ARG non_root_user=dind
ARG uid=1000
ARG gid=1000

# 👤 Rename non root user
RUN usermod -l ${non_root_user} ${USER} \
    && groupmod -n ${non_root_user} ${USER} \
    && \
    echo "${non_root_user}:${non_root_user}" | chpasswd && \
    adduser ${non_root_user} sudo && \
    echo "${non_root_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${non_root_user} && \
    chmod 0440 /etc/sudoers.d/${non_root_user}

ENV XDG_RUNTIME_DIR="/run/user/${uid}"

RUN mkdir -p ${XDG_RUNTIME_DIR} && \
    chmod 700 ${XDG_RUNTIME_DIR} && \
    chown ${uid}:${gid} ${XDG_RUNTIME_DIR}

ENV USER=${non_root_user}
COPY container-entrypoint.sh /usr/local/bin/debian-dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/debian-dockerd-entrypoint.sh

COPY container-install.sh /usr/local/bin/debian-dockerd-install.sh
RUN chmod +x /usr/local/bin/debian-dockerd-install.sh

COPY container-dind-start.sh /usr/local/bin/debian-dind-start.sh
RUN chmod +x /usr/local/bin/debian-dind-start.sh

COPY --from=docker-dind /usr/local/bin/dockerd-entrypoint.sh  /usr/local/bin/
COPY --from=docker-dind /usr/local/bin/docker-entrypoint.sh   /usr/local/bin/
COPY --from=docker-dind /usr/local/bin/modprobe               /usr/local/bin/

USER ${non_root_user}

ENV USER=${non_root_user}

ENTRYPOINT ["tini", "--", "debian-dockerd-entrypoint.sh"]
CMD ["debian-dind-start.sh"]
HEALTHCHECK CMD test -f /tmp/.dockerd-ready || exit 1