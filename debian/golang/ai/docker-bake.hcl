variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-golang-ai-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-golang-ai-latest"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-golang-ai"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-golang-ai-version"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-golang-ai-latest"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-golang-ai-ci" {
  description = "Build and push Android Emmulator images"
  targets = [
    "vegito-debian-golang-ai-version-ci",
    "vegito-debian-golang-ai-latest-ci",
  ]
}

target "vegito-debian-golang-ai-version-ci" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker-version-ci"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}


variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-golang-ai-docker-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-golang-ai-docker"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-golang-ai-docker-version"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-golang-ai-docker-ci" {
  description = "Build and push Android Emmulator images"
  targets = [
    "vegito-debian-golang-ai-docker-version-ci",
    "vegito-debian-golang-ai-docker-latest-ci",
  ]
}

target "vegito-debian-golang-ai-docker-version-ci" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker-version-ci"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-golang-ai-docker-latest-ci" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker-latest-ci"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-golang-ai-docker" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-golang-ai-docker-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-golang-ai-docker-desktop-x-latest"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/debian-golang-ai-docker-desktop-x"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-golang-ai-docker-desktop-x-version"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-golang-ai-docker-desktop-x-latest"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-debian-golang-ai-docker-desktop-x-ci" {
  description = "Build and push Android Emmulator images"
  targets = [
    "vegito-debian-golang-ai-docker-desktop-x-version-ci",
    "vegito-debian-golang-ai-docker-desktop-x-latest-ci",
  ]
}

target "vegito-debian-golang-ai-docker-desktop-x-version-ci" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker-desktop-x-version-ci"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-golang-ai-docker-desktop-x-latest-ci" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker-desktop-x-latest-ci"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-golang-ai-docker-desktop-x" {
  inherits = ["vegito-debian-golang-base"]
  contexts = {
    debian           = "target:vegito-debian-ai-docker-desktop-x"
    dockerhub_golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_VERSION,
    VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_GOLANG_AI_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}
