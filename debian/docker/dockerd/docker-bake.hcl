variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DOCKER_DIR}/dockerd"
}
variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-dockerd-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-dockerd-latest"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-dockerd"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-dockerd-version"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-dockerd-latest"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_LATEST}"
}

target "vegito-debian-dockerd-base" {
  args = {
    debian_version = "bookworm"
    docker_version = DOCKER_VERSION
  }
  context = VEGITO_DOCKER_DEBIAN_DOCKERD_DIR
}

group "vegito-debian-dockerd-ci" {
  targets = [
    "vegito-debian-dockerd-version-ci",
    "vegito-debian-dockerd-latest-ci",
  ]
}

group "vegito-debian-dockerd-desktop-x-ci" {
  targets = [
    "vegito-debian-dockerd-desktop-x-version-ci",
    "vegito-debian-dockerd-desktop-x-latest-ci",
  ]
}

target "vegito-debian-dockerd-version-ci" {
  inherits = ["vegito-debian-dockerd-base"]
  contexts = {
    debian               = "target:vegito-debian-docker-version-ci"
    debian_golang        = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    docker_dind = "docker-image://${VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-dockerd-latest-ci" {
  inherits = ["vegito-debian-dockerd-base"]
  contexts = {
    debian               = "target:vegito-debian-docker-latest-ci"
    debian_golang        = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
    docker_dind = "docker-image://${VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-dockerd" {
  inherits = ["vegito-debian-dockerd-base"]
  contexts = {
    debian               = "target:vegito-debian-docker"
    debian_golang        = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
    docker_dind = "docker-image://${VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-dockerd-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-dockerd-desktop-x-latest"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-dockerd-desktop-x"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-dockerd-desktop-x-version"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-dockerd-desktop-x-latest"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_LATEST}"
}

target "vegito-debian-dockerd-desktop-x-version-ci" {
  contexts = {
    debian               = "target:vegito-debian-docker-desktop-x-version-ci"
    debian_golang        = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    docker_dind = "docker-image://${VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST}"
  }
  inherits = ["vegito-debian-dockerd-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-dockerd-desktop-x-latest-ci" {
  inherits = ["vegito-debian-dockerd-base"]
  contexts = {
    debian = "target:vegito-debian-docker-desktop-x-latest-ci"
    debian_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
    docker_dind = "docker-image://${VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-dockerd-desktop-x" {
  inherits = ["vegito-debian-dockerd-base"]
  contexts = {
    debian = "target:vegito-debian-docker-desktop-x"
    debian_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
    docker_dind = "docker-image://${VEGITO_DOCKER_HUB_DIND_ROOTLESS_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKERD_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_DOCKERD_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}
