
variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-docker-desktop-x-latest"
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

group "vegito-debian-project-docker-desktop-x-ci" {
  targets = [
    "vegito-debian-project-docker-desktop-x-version-ci",
    "vegito-debian-project-docker-desktop-x-latest-ci",
  ]
}

target "vegito-debian-project-docker-desktop-x-version-ci" {
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker-desktop-x-version-ci"
  }
  inherits = ["vegito-debian-project-version-ci"]
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_DESKTOP_X_IMAGE_VERSION,
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

target "vegito-debian-project-docker-desktop-x-latest-ci" {
  inherits = ["vegito-debian-project-latest-ci"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_DEBIAN_GOLANG_DESKTOP_X_IMAGE_LATEST}"
    debian        = "target:vegito-debian-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_DESKTOP_X_IMAGE_LATEST,
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

target "vegito-debian-project-docker-desktop-x" {
  inherits = ["vegito-debian-project"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
    debian        = "target:vegito-debian-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_DESKTOP_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_PROJECT_DOCKER_DESKTOP_X_IMAGE_LATEST,
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
