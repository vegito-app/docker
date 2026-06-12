FROM debian

USER root

ARG TARGETPLATFORM

ARG debian_version=bookworm
RUN --mount=type=cache,id=vegito-debian-${debian_version}-${TARGETPLATFORM}-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=vegito-debian-${debian_version}-${TARGETPLATFORM}-apt-lib,target=/var/lib/apt,sharing=locked \
    apt-get -o Acquire::Retries=3 update && apt-get install -y \
    python3 python3-pip python3-venv

ARG non_root_user=flutter
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

USER ${non_root_user}

ENV USER=${non_root_user}

RUN python3 -m venv ${HOME}/venv

ENV PATH="${HOME}/venv/bin:$PATH"

COPY container-entrypoint.sh /usr/local/bin/python-container-entrypoint.sh
COPY container-install.sh /usr/local/bin/python-container-install.sh

ENTRYPOINT [ "python-container-entrypoint.sh" ]