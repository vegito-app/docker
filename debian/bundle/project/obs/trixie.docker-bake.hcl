variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-obs-vscode-golang-ai-dockerd-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-project-obs-vscode-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/trixie-debian-project-obs-vscode-golang-ai-dockerd"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-obs-vscode-golang-ai-dockerd-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/trixie-debian-project-obs-vscode-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

group "vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd-ci" {
  targets = [
    "vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd-version-ci",
    "vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd-latest-ci",
  ]
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd-version-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-obs-vscode-golang-ai-dockerd-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION,
    ] : []
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd-latest-ci" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-obs-vscode-golang-ai-dockerd-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-project-obs-vscode-golang-ai-dockerd" {
  inherits = ["vegito-trixie-debian-project-base"]
  contexts = {
    debian-golang = "docker-image://${VEGITO_DOCKER_HUB_GOLANG_DEBIAN_TRIXIE_IMAGE_VERSION}"
    debian        = "target:vegito-trixie-debian-obs-vscode-golang-ai-dockerd"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE}",
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST,
      VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_PROJECT_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST,
    ] : []
  )
}
