variable "VEGITO_DESKTOP_X_VERSION" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:desktop-x-${VERSION}"
}

variable "VEGITO_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/vegito-desktop-x"
}

variable "VEGITO_DESKTOP_X_DIR" {
  default = "${VEGITO_DOCKER_DIR}/desktop-x"
}

variable "VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/desktop-x-version"
}

variable "VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/desktop-x-latest"
}

variable "VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-desktop-x version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-desktop-x latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-desktop-x version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-desktop-x latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:desktop-x-latest"
}

variable "VEGITO_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:desktop-x-${VERSION}"
}

group "vegito-desktop-x-ci" {
  description = "Build and push Android Emmulator images"
  targets = [
    "vegito-desktop-x-version-ci",
    "vegito-desktop-x-latest-ci",
  ]
}

target "vegito-desktop-x-version-ci" {
  context = VEGITO_DESKTOP_X_DIR
  contexts = {
    debian = "target:debian-version-ci"
  }
  tags = [
    VEGITO_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      "type=inline,ref=${VEGITO_DESKTOP_X_IMAGE_LATEST}"
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-desktop-x-latest-ci" {
  context = VEGITO_DESKTOP_X_DIR
  contexts = {
    debian = "target:debian-latest-ci"
  }
  tags = [
    VEGITO_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      "type=inline,ref=${VEGITO_DESKTOP_X_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-desktop-x" {

  context = VEGITO_DESKTOP_X_DIR
  contexts = {
    debian = "target:debian-version-ci"
  }
  tags = [
    VEGITO_DESKTOP_X_IMAGE_LATEST,
    VEGITO_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      "type=inline,ref=${VEGITO_DESKTOP_X_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}
