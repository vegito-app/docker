variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-vscode-golang-ai-docker-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/vegito-trixie-debian-vscode-golang-ai-docker"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-vscode-golang-ai-docker-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for vegito-trixie-debian-vscode-golang-ai-docker version image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for vegito-trixie-debian-vscode-golang-ai-docker latest image build"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache for vegito-trixie-debian-vscode-golang-ai-docker version image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache for vegito-trixie-debian-vscode-golang-ai-docker latest image build (cannot be used before first write)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-vscode-golang-ai-docker-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-vscode-golang-ai-docker-${VERSION}"
}

group "vegito-trixie-debian-vscode-golang-ai-docker-ci" {
  description = "Build and push Android Emmulator images"
  targets = [
    "vegito-trixie-debian-vscode-golang-ai-docker-version-ci",
    "vegito-trixie-debian-vscode-golang-ai-docker-latest-ci",
  ]
}

target "vegito-trixie-debian-vscode-golang-ai-docker-version-ci" {
  inherits = ["vegito-debian-vscode-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-ai-docker-desktop-x-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-vscode-golang-ai-docker-latest-ci" {
  inherits = ["vegito-debian-vscode-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-ai-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-vscode-golang-ai-docker" {

  inherits = ["vegito-debian-vscode-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-golang-ai-docker-desktop-x-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_LATEST,
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_VSCODE_GOLANG_AI_DOCKER_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}
