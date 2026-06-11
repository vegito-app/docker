target "docker-debian-project" {
  contxexts = {
    local = "target:docker-debian-project-local"
  }
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/project"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-x-latest"
}



variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-project"
}


variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-version"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-projects" {
  targets = [
    "vegito-debian-project",
    "vegito-debian-project-x",
  ]
}

group "vegito-debian-projects-ci" {
  targets = [
    "vegito-debian-project-ci",
    "vegito-debian-project-x-ci",
  ]
}

group "vegito-debian-project-ci" {
  targets = [
    "vegito-debian-project-version-ci",
    "vegito-debian-project-latest-ci",
  ]
}

group "vegito-debian-project-x-ci" {
  targets = [
    "vegito-debian-project-x-version-ci",
    "vegito-debian-project-x-latest-ci",
  ]
}

group "vegito-debian-project-vscode-golang-ci" {
  targets = [
    "vegito-debian-project-vscode-golang-version-ci",
    "vegito-debian-project-vscode-golang-latest-ci",
  ]
}

group "vegito-debian-project-vscode-golang-ci" {
  targets = [
    "vegito-debian-project-vscode-golang-version-ci",
    "vegito-debian-project-vscode-golang-latest-ci",
  ]
}

group "vegito-debian-project-vscode-golang-ai-docker-ci" {
  targets = [
    "vegito-debian-project-vscode-golang-ai-docker-version-ci",
    "vegito-debian-project-vscode-golang-ai-docker-latest-ci",
  ]
}

group "vegito-debian-project-obs-vscode-golang-ai-docker-ci" {
  targets = [
    "vegito-debian-project-obs-vscode-golang-ai-docker-version-ci",
    "vegito-debian-project-obs-vscode-golang-ai-docker-latest-ci",
  ]
}
target "vegito-debian-project-base" {
  args = {
    gitleaks_version       = GITLEAKS_VERSION
    k9s_version            = K9S_VERSION
    kubectl_version        = KUBECTL_VERSION
    node_version           = NODE_VERSION
    nvm_version            = NVM_VERSION
    oh_my_zsh_version      = OH_MY_ZSH_VERSION
    terraform_version      = TERRAFORM_VERSION
  }
  context    = VEGITO_DOCKER_DEBIAN_PROJECT_DIR
  dockerfile = "Dockerfile"
}

target "vegito-debian-project-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-desktop-x-version-ci"
  }
  inherits = ["vegito-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_X_IMAGE_VERSION,
  ]
}

target "vegito-debian-project-version-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-project-x-latest-ci" {
  inherits = ["vegito-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-debian-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-latest-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_REGISTR_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-project-x" {
  inherits = ["vegito-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_PROJECT_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-x-latest"
}



variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-project-docker"
}


variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-docker-version"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-project-docker-ci" {
  targets = [
    "vegito-debian-project-docker-version-ci",
    "vegito-debian-project-docker-latest-ci",
  ]
}

group "vegito-debian-project-docker-x-ci" {
  targets = [
    "vegito-debian-project-docker-x-version-ci",
    "vegito-debian-project-docker-x-latest-ci",
  ]
}

target "vegito-debian-project-docker-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker-desktop-x-version-ci"
  }
  inherits = ["vegito-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_X_IMAGE_VERSION,
  ]
}

target "vegito-debian-project-docker-version-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker-version-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-project-docker-x-latest-ci" {
  inherits = ["vegito-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-debian-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-docker-latest-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTR_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-project-docker-x" {
  inherits = ["vegito-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-docker" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-vscode-golang-ai-docker-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-vscode-golang-ai-docker-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-vscode-golang-ai-docker-x-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-project-vscode-golang-ai-docker"
}


variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-vscode-golang-ai-docker-version"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-project-vscode-golang-ai-docker-ci" {
  targets = [
    "vegito-debian-project-vscode-golang-ai-docker-version-ci",
    "vegito-debian-project-vscode-golang-ai-docker-latest-ci",

    "vegito-debian-project-vscode-golang-ai-docker-version-ci",
    "vegito-debian-project-vscode-golang-ai-docker-latest-ci"
  ]
}

group "vegito-debian-project-vscode-golang-ai-docker-x-ci" {
  targets = [
    "vegito-debian-project-vscode-golang-ai-docker-x-version-ci",
    "vegito-debian-project-vscode-golang-ai-docker-x-latest-ci",
  ]
}

target "vegito-debian-project-vscode-golang-ai-docker-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker-desktop-x-version-ci"
  }
  inherits = ["vegito-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
  ]
}

target "vegito-debian-project-vscode-golang-ai-docker-version-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker-version-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-project-vscode-golang-ai-docker-x-latest-ci" {
  inherits = ["vegito-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-vscode-golang-ai-docker-latest-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-project-vscode-golang-ai-docker-x" {
  inherits = ["vegito-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-vscode-golang-ai-docker" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-obs-vscode-golang-ai-docker-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-obs-vscode-golang-ai-docker-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-obs-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-obs-vscode-golang-ai-docker-x-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-project-obs-vscode-golang-ai-docker"
}


variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-obs-vscode-golang-ai-docker-version"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-obs-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-project-obs-vscode-golang-ai-docker-ci" {
  targets = [
    "vegito-debian-project-obs-vscode-golang-ai-docker-version-ci",
    "vegito-debian-project-obs-vscode-golang-ai-docker-latest-ci",

    "vegito-debian-project-obs-vscode-golang-ai-docker-version-ci",
    "vegito-debian-project-obs-vscode-golang-ai-docker-latest-ci"
  ]
}

group "vegito-debian-project-obs-vscode-golang-ai-docker-x-ci" {
  targets = [
    "vegito-debian-project-obs-vscode-golang-ai-docker-x-version-ci",
    "vegito-debian-project-obs-vscode-golang-ai-docker-x-latest-ci",
  ]
}

target "vegito-debian-project-obs-vscode-golang-ai-docker-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker-version-ci"
  }
  inherits = ["vegito-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
  ]
}

target "vegito-debian-project-obs-vscode-golang-ai-docker-version-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-obs-vscode-golang-ai-docker-version-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-project-obs-vscode-golang-ai-docker-x-latest-ci" {
  inherits = ["vegito-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-debian-obs-vscode-golang-ai-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-obs-vscode-golang-ai-docker-latest-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-obs-vscode-golang-ai-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-project-obs-vscode-golang-ai-docker-x" {
  inherits = ["vegito-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-debian-project-obs-vscode-golang-ai-docker" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-vscode-golang-ai-docker"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}
