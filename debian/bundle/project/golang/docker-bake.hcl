variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-golang-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-debian-project-golang"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/vscode"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-golang-version"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-golang-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-debian-project-golang version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-debian-project-golang latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-debian-project-golang version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-debian-project-golang latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-golang-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-golang-${VERSION}"
}

group "vegito-debian-project-golang-ci" {
  description = "Build and push Debian VSCode images"
  targets = [
    "vegito-debian-project-golang-version-ci",
    "vegito-debian-project-golang-latest-ci",
  ]
}

target "vegito-debian-project-golang-version-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian = "target:vegito-debian-golang-version-ci"
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_IMAGE_VERSION}"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-project-golang-latest-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian = "target:vegito-debian-golang-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-project-golang" {

  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian = "target:vegito-debian-golang-ai-dockerd-version-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}
variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-golang-ai-dockerd-${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/vegito-debian-project-golang-ai-dockerd"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/vscode"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-golang-ai-dockerd-version"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian-project-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-debian-project-golang-ai-dockerd version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-debian-project-golang-ai-dockerd latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-debian-project-golang-ai-dockerd version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-debian-project-golang-ai-dockerd latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:debian-project-golang-ai-dockerd-${VERSION}"
}

group "vegito-debian-project-golang-ai-dockerd-ci" {
  description = "Build and push Debian VSCode images"
  targets = [
    "vegito-debian-project-golang-ai-dockerd-version-ci",
    "vegito-debian-project-golang-ai-dockerd-latest-ci",
  ]
}

target "vegito-debian-project-golang-ai-dockerd-version-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian = "target:vegito-debian-golang-ai-dockerd-desktop-x-version-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-debian-project-golang-ai-dockerd-latest-ci" {
  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian = "target:vegito-debian-golang-ai-dockerd-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-debian-project-golang-ai-dockerd" {

  inherits = ["vegito-debian-project-base"]
  contexts = {
    debian = "target:vegito-debian-golang-ai-dockerd-version-ci"
  }
  tags = [
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_PROJECT_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}
