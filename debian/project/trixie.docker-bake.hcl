target "docker-trixie-debian-project" {
  contxexts = {
    local = "target:docker-trixie-debian-project-local"
  }
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-x-latest"
}



variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/trixie-debian-project"
}


variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-trixie-debian-projects" {
  targets = [
    "vegito-trixie-debian-project",
    "vegito-trixie-debian-project-x",
  ]
}

group "vegito-trixie-debian-projects-ci" {
  targets = [
    "vegito-trixie-debian-project-ci",
    "vegito-trixie-debian-project-x-ci",
  ]
}

group "vegito-trixie-debian-project-ci" {
  targets = [
    "vegito-trixie-debian-project-version-ci",
    "vegito-trixie-debian-project-latest-ci",
  ]
}

group "vegito-trixie-debian-project-x-ci" {
  targets = [
    "vegito-trixie-debian-project-x-version-ci",
    "vegito-trixie-debian-project-x-latest-ci",
  ]
}

group "vegito-trixie-debian-project-vscode-golang-ci" {
  targets = [
    "vegito-trixie-debian-project-vscode-golang-version-ci",
    "vegito-trixie-debian-project-vscode-golang-latest-ci",
  ]
}

group "vegito-trixie-debian-project-vscode-golang-ci" {
  targets = [
    "vegito-trixie-debian-project-vscode-golang-version-ci",
    "vegito-trixie-debian-project-vscode-golang-latest-ci",
  ]
}

target "vegito-trixie-debian-project-base" {
  inherits = ["vegito-debian-project-base"]
  args = {
    debian_version = "trixie"
  }
}

target "vegito-trixie-debian-project-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-desktop-x-version-ci"
  }
  inherits = ["vegito-trixie-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_X_IMAGE_VERSION,
  ]
}

target "vegito-trixie-debian-project-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-x-latest-ci" {
  inherits = ["vegito-trixie-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_TRIXIE_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-trixie-debian-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_REGISTR_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-x" {
  inherits = ["vegito-trixie-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_X_IMAGE_VERSION,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-docker-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-docker-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-docker-x-latest"
}



variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/trixie-debian-project-docker"
}


variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-docker-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-trixie-debian-project-docker-ci" {
  targets = [
    "vegito-trixie-debian-project-docker-version-ci",
    "vegito-trixie-debian-project-docker-latest-ci",
  ]
}

group "vegito-trixie-debian-project-docker-x-ci" {
  targets = [
    "vegito-trixie-debian-project-docker-x-version-ci",
    "vegito-trixie-debian-project-docker-x-latest-ci",
  ]
}

target "vegito-trixie-debian-project-docker-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-docker-desktop-x-version-ci"
  }
  inherits = ["vegito-trixie-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_X_IMAGE_VERSION,
  ]
}

target "vegito-trixie-debian-project-docker-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-docker-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-docker-x-latest-ci" {
  inherits = ["vegito-trixie-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_TRIXIE_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-trixie-debian-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-docker-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTR_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-docker-x" {
  inherits = ["vegito-trixie-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_X_IMAGE_VERSION,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-docker" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-docker"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-vscode-golang-ai-docker-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-vscode-golang-ai-docker-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-vscode-golang-ai-docker-x-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/trixie-debian-project-vscode-golang-ai-docker"
}


variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-vscode-golang-ai-docker-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-trixie-debian-project-vscode-golang-ai-docker-ci" {
  targets = [
    "vegito-trixie-debian-project-vscode-golang-ai-docker-version-ci",
    "vegito-trixie-debian-project-vscode-golang-ai-docker-latest-ci",

    "vegito-trixie-debian-project-vscode-golang-ai-docker-version-ci",
    "vegito-trixie-debian-project-vscode-golang-ai-docker-latest-ci"
  ]
}

group "vegito-trixie-debian-project-vscode-golang-ai-docker-x-ci" {
  targets = [
    "vegito-trixie-debian-project-vscode-golang-ai-docker-x-version-ci",
    "vegito-trixie-debian-project-vscode-golang-ai-docker-x-latest-ci",
  ]
}

target "vegito-trixie-debian-project-vscode-golang-ai-docker-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-desktop-x-version-ci"
  }
  inherits = ["vegito-trixie-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
  ]
}

target "vegito-trixie-debian-project-vscode-golang-ai-docker-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-vscode-golang-ai-docker-x-latest-ci" {
  inherits = ["vegito-trixie-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_TRIXIE_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-trixie-debian-golang-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-vscode-golang-ai-docker-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-vscode-golang-ai-docker-x" {
  inherits = ["vegito-trixie-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-vscode-golang-ai-docker" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-obs-vscode-golang-ai-docker-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-obs-vscode-golang-ai-docker-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-obs-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-obs-vscode-golang-ai-docker-x-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/trixie-debian-project-obs-vscode-golang-ai-docker"
}


variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-obs-vscode-golang-ai-docker-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-obs-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-ci" {
  targets = [
    "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-version-ci",
    "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-latest-ci",

    "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-version-ci",
    "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-latest-ci"
  ]
}

group "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-x-ci" {
  targets = [
    "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-x-version-ci",
    "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-x-latest-ci",
  ]
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-desktop-x-version-ci"
  }
  inherits = ["vegito-trixie-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
  ]
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-x-latest-ci" {
  inherits = ["vegito-trixie-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_TRIXIE_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-trixie-debian-golang-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-docker-x" {
  inherits = ["vegito-trixie-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_VERSION,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-docker" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-golang-docker"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}
