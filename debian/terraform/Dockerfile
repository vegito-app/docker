FROM debian

ARG TARGETPLATFORM

USER root
ARG debian_version=bookworm

# Terraform
ARG terraform_version=1.11.2
RUN curl -OL https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip \
    && unzip terraform_${terraform_version}_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_${terraform_version}_linux_amd64.zip

ARG non_root_user=local
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


