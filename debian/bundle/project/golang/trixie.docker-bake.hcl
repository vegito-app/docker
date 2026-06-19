variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-trixie-debian-project-golang"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-trixie-debian-project-golang version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-trixie-debian-project-golang latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-trixie-debian-project-golang version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-trixie-debian-project-golang latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-${VERSION}"
}

group "vegito-trixie-debian-project-golang-ci" {
  description = "Build and push Project Golang images"
  targets = [
    "vegito-trixie-debian-project-golang-version-ci",
    "vegito-trixie-debian-project-golang-latest-ci",
  ]
}

target "vegito-trixie-debian-project-golang-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-latest-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang" {

  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-trixie-debian-project-golang-desktop-x"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-desktop-x-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-desktop-x-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-trixie-debian-project-golang-desktop-x version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-trixie-debian-project-golang-desktop-x latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-trixie-debian-project-golang-desktop-x version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-trixie-debian-project-golang-desktop-x latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-desktop-x-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-desktop-x-${VERSION}"
}

group "vegito-trixie-debian-project-golang-desktop-x-ci" {
  description = "Build and push Project Golang Desktop X images"
  targets = [
    "vegito-trixie-debian-project-golang-desktop-x-version-ci",
    "vegito-trixie-debian-project-golang-desktop-x-latest-ci",
  ]
}

target "vegito-trixie-debian-project-golang-desktop-x-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-desktop-x-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-latest-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-desktop-x" {

  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-desktop-x-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-docker-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-trixie-debian-project-golang-docker"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-docker-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-trixie-debian-project-golang-docker version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-trixie-debian-project-golang-docker latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-trixie-debian-project-golang-docker version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-trixie-debian-project-golang-docker latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-docker-${VERSION}"
}

group "vegito-trixie-debian-project-golang-docker-ci" {
  description = "Build and push Project Golang Docker images"
  targets = [
    "vegito-trixie-debian-project-golang-docker-version-ci",
    "vegito-trixie-debian-project-golang-docker-latest-ci",
  ]
}

target "vegito-trixie-debian-project-golang-docker-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-docker-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-latest-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-docker" {

  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-docker-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-docker-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-trixie-debian-project-golang-docker-desktop-x"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-docker-desktop-x-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-docker-desktop-x-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-trixie-debian-project-golang-docker-desktop-x version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-trixie-debian-project-golang-docker-desktop-x latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-trixie-debian-project-golang-docker-desktop-x version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-trixie-debian-project-golang-docker-desktop-x latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-docker-desktop-x-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-docker-desktop-x-${VERSION}"
}

group "vegito-trixie-debian-project-golang-docker-desktop-x-ci" {
  description = "Build and push Project Golang Docker Desktop X images"
  targets = [
    "vegito-trixie-debian-project-golang-docker-desktop-x-version-ci",
    "vegito-trixie-debian-project-golang-docker-desktop-x-latest-ci",
  ]
}

target "vegito-trixie-debian-project-golang-docker-desktop-x-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-docker-desktop-x-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-docker-desktop-x-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-docker-desktop-x-latest-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-docker-desktop-x" {

  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-docker-desktop-x-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_DOCKER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-ai-dockerd-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-trixie-debian-project-golang-ai-dockerd"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-ai-dockerd-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-trixie-debian-project-golang-ai-dockerd version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-trixie-debian-project-golang-ai-dockerd latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-trixie-debian-project-golang-ai-dockerd version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-trixie-debian-project-golang-ai-dockerd latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-golang-ai-dockerd-${VERSION}"
}

group "vegito-trixie-debian-project-golang-ai-docker-ci" {
  description = "Build and push Project Golang AI Docker images"
  targets = [
    "vegito-trixie-debian-project-golang-ai-docker-version-ci",
    "vegito-trixie-debian-project-golang-ai-docker-latest-ci",
  ]
}

target "vegito-trixie-debian-project-golang-ai-docker-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-ai-docker-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-latest-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_LATEST}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-golang-ai-docker" {

  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-ai-docker-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}


