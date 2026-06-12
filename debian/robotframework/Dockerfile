FROM debian

USER root

ARG TARGETPLATFORM

ARG debian_version=bookworm

ARG non_root_user=robot
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

RUN --mount=type=cache,id=vegito-robotframework-${debian_version}-${TARGETPLATFORM}-pip-cache,target=/home/${non_root_user}/.cache/pip,sharing=locked,uid=${uid},gid=${gid} \
    pip install \
    robotframework \
    robotframework-appiumlibrary \
    robotframework-requests \
    robotframework-seleniumlibrary \
    robotframework-faker

COPY container-entrypoint.sh /usr/local/bin/robotframework-container-entrypoint.sh
COPY container-install.sh /usr/local/bin/robotframework-container-install.sh
COPY container-start.sh /usr/local/bin/robotframework-container-start.sh

ENV LOCAL_ROBOTFRAMEWORK_TESTS_DIR=${HOME}/robotframework

WORKDIR ${LOCAL_ROBOTFRAMEWORK_TESTS_DIR}

ENTRYPOINT ["tini", "--", "robotframework-container-entrypoint.sh" ]
CMD [ "robotframework-container-start.sh" ]