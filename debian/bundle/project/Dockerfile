FROM debian-golang AS go-build
ARG debian_version=bookworm
ARG TARGETPLATFORM

ARG uid=1000
ARG gid=1000
ARG go_pkg=/home/debian/go/pkg
ARG go_cache=/home/debian/.cache/go-build
ENV GOMODCACHE=${go_pkg}/mod
ENV GOCACHE=${go_cache}
ENV GOBIN=/home/debian/go/bin
ENV CGO_ENABLED=0
RUN --mount=type=cache,id=vegito-debian-${TARGETPLATFORM}-${debian_version}-root-go-pkg,target=${go_pkg},sharing=locked,uid=${uid},gid=${gid} \
    --mount=type=cache,id=vegito-debian-${TARGETPLATFORM}-${debian_version}-root-go-build,target=${go_cache},sharing=locked,uid=${uid},gid=${gid} \
    go install -v github.com/jesseduffield/lazydocker@latest \
    && go install -v github.com/vegito-app/local/proxy@e57ffca0fce2a5382ecb3da5293e2470b932fc7f

FROM debian

ARG TARGETPLATFORM

USER root
ARG debian_version=bookworm

RUN --mount=type=cache,id=vegito-debian-${debian_version}-${TARGETPLATFORM}-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=vegito-debian-${debian_version}-${TARGETPLATFORM}-apt-lib,target=/var/lib/apt,sharing=locked \
    if [ "${debian_version}" = "trixie" ]; then \
    JAVA_PACKAGE=default-jdk; \
    LIBNCURSES_PACKAGE=libncurses6; \
    else \
    JAVA_PACKAGE=openjdk-17-jdk; \
    LIBNCURSES_PACKAGE=libncurses5; \
    fi; \
    apt-get -o Acquire::Retries=3 update && apt-get install -y \
    build-essential \
    g++ \
    gcc \
    gcc \
    libbz2-1.0 \
    libc6 \
    libcairo2-dev \
    libgif-dev \
    libglu1-mesa \
    libjpeg-dev \
    libpango1.0-dev \
    librsvg2-dev \
    libstdc++6 \
    lsb-release \
    ${JAVA_PACKAGE} \
    ${LIBNCURSES_PACKAGE}

# GCP CLI
RUN --mount=type=cache,id=local-builder-${TARGETPLATFORM}-apt-cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,id=local-builder-${TARGETPLATFORM}-apt-lib,target=/var/lib/apt,sharing=locked \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
    && apt-get -o Acquire::Retries=3 update && apt-get install -y \
    google-cloud-cli-gke-gcloud-auth-plugin \
    google-cloud-sdk

ARG gitleaks_version=8.28.0

RUN case "$TARGETPLATFORM" in "linux/amd64") \
    url="https://github.com/gitleaks/gitleaks/releases/download/v${gitleaks_version}/gitleaks_${gitleaks_version}_linux_x64.tar.gz" ; \
    ;; \
    "linux/arm64") \
    url="https://github.com/gitleaks/gitleaks/releases/download/v${gitleaks_version}/gitleaks_${gitleaks_version}_linux_arm64.tar.gz" ; \
    ;; \
    *) echo >&2 "warning: unsupported 'gitleaks' architecture ($TARGETPLATFORM); skipping"; exit 0 ;; \
    esac; \
    echo "Downloading gitleaks from $url"; \
    curl -L -o /tmp/gitleaks.tar.gz $url \
    && mkdir -p /tmp/gitleaks \
    && tar -xvzf /tmp/gitleaks.tar.gz -C /tmp/gitleaks \
    && mv /tmp/gitleaks/gitleaks /usr/local/bin/gitleaks \
    && rm -rf /tmp/gitleaks \
    && gitleaks version

ARG non_root_user=project
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

WORKDIR ${HOME}

ENV PATH=${PATH}:${HOME}/go/bin

ENV NVM_DIR=${HOME}/nvm

ARG nvm_version
ARG node_version
RUN --mount=type=cache,id=local-builder-${debian_version}-${TARGETPLATFORM}-npm-cache,target=${HOME}/.npm,sharing=locked,uid=${uid},gid=${gid} \
    --mount=type=cache,id=local-builder-${debian_version}-${TARGETPLATFORM}-node-gyp,target=${HOME}/.cache/node-gyp,sharing=locked,uid=${uid},gid=${gid} \
    set -e ; \
    # 
    mkdir -p ${NVM_DIR} ; \
    #
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${nvm_version}/install.sh | bash - ; \
    . ${NVM_DIR}/nvm.sh ; \
    nvm install ${node_version} ; \
    nvm alias default ${node_version} ; \
    nvm use default ;  \
    # 
    npm install -g \
    depcheck \
    firebase-tools \
    npm-check-updates \
    npm-check \
    npm \
    @devcontainers/cli

ENV NODE_PATH=$NVM_DIR/versions/node/v${node_version}/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v${node_version}/bin:$PATH

ENV PATH=${HOME}/bin:$PATH

COPY container-entrypoint.sh /usr/local/bin/project-container-entrypoint.sh
COPY container-install.sh /usr/local/bin/project-container-install.sh
COPY container-start.sh /usr/local/bin/project-container-start.sh

COPY --from=go-build /home/debian/go/bin/proxy /usr/local/bin/localproxy

ENTRYPOINT [ "project-container-entrypoint.sh" ]
CMD [ "project-container-start.sh" ]

