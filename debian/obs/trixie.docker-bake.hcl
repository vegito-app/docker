variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/obs"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}-obs"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/trixie-debian-obs:latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/trixie-debian-obs:${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}-obs"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

group "vegito-trixie-debian-obs-local" {
  targets = [
    "vegito-trixie-debian-obs",
  ]
}

group "vegito-trixie-debian-obs-ci" {
  targets = [
    "vegito-trixie-debian-obs-version-ci",
    "vegito-trixie-debian-obs-latest-ci",
  ]
}

target "vegito-trixie-debian-obs-base" {
  context = VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_DIR
  args = {
    debian_version = "trixie"
  }
}

target "vegito-trixie-debian-obs-version-ci" {
  inherits = ["vegito-trixie-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-desktop-x-version-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "vegito-trixie-debian-obs-latest-ci" {
  inherits = ["vegito-trixie-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_LATEST,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-desktop-x-latest-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "vegito-trixie-debian-obs" {
  inherits = ["vegito-trixie-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-desktop-x"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/obs-vscode-golang-ai-dockerd"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}-obs-vscode-golang-ai-dockerd"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/trixie-debian-obs-vscode-golang-ai-dockerd-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/trixie-debian-obs-vscode-golang-ai-dockerd:${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}-obs-vscode-golang-ai-dockerd"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

group "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-local" {
  targets = [
    "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-version",
  ]
}

group "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-ci" {
  targets = [
    "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-version-ci",
    "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-latest-ci",
  ]
}

target "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-version-ci" {
  inherits = ["vegito-trixie-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-vscode-golang-ai-dockerd-version-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "vegito-trixie-debian-obs-vscode-golang-ai-dockerd-latest-ci" {
  inherits = ["vegito-trixie-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-vscode-golang-ai-dockerd-latest-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "vegito-trixie-debian-obs-vscode-golang-ai-dockerd" {
  inherits = ["vegito-trixie-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-vscode-golang-ai-dockerd"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}
