variable "VEGITO_DOCKER_DEBIAN_OBS_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/obs"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}-obs"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/debian-obs:latest"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/debian-obs:${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}-obs"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

group "vegito-debian-obs-ci" {
  targets = [
    "vegito-debian-obs-version-ci",
    "vegito-debian-obs-latest-ci",
  ]
}

target "vegito-debian-obs-base" {
  context = VEGITO_DOCKER_DEBIAN_OBS_DIR
}

target "vegito-debian-obs-version-ci" {
  inherits = ["vegito-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-debian-desktop-x-version-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "vegito-debian-obs-latest-ci" {
  inherits = ["vegito-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST,
  ]
  contexts = {
    debian = "target:vegito-debian-desktop-x-latest-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "vegito-debian-obs" {
  inherits = ["vegito-debian-obs-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:debian-desktop-x"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}


variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/obs"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_DEBIAN_IMAGE_REGISTRY_CACHE}-obs"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}-debian-obs:latest"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}-debian-obs:${VERSION}"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}-obs"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DOCKER_DEBIAN_OBS_VSCODE_GOLANG_AI_DOCKERD_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}


group "vegito-debian-obs-vscode-golang-ai-dockerd" {
  targets = [
    "vegito-debian-obs-vscode-golang-ai-dockerd-version",
    "vegito-debian-obs-vscode-golang-ai-dockerd-latest",
  ]
}
group "vegito-debian-obs-vscode-golang-ai-dockerd-ci" {
  targets = [
    "vegito-debian-obs-vscode-golang-ai-dockerd-version-ci",
    "vegito-debian-obs-vscode-golang-ai-dockerd-latest-ci",
  ]
}

target "vegito-debian-obs-vscode-golang-ai-dockerd-base" {
  context = VEGITO_DOCKER_DEBIAN_OBS_DIR
  args = {
    debian_version = "bookworm"
  }
}

target "vegito-debian-obs-vscode-golang-ai-dockerd-version-ci" {
  inherits = ["vegito-debian-obs-vscode-golang-ai-dockerd-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-debian-golang-ai-dockerd-desktop-x-version-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "vegito-debian-obs-vscode-golang-ai-dockerd-latest-ci" {
  inherits = ["vegito-debian-obs-vscode-golang-ai-dockerd-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST,
  ]
  contexts = {
    debian = "target:vegito-debian-golang-ai-dockerd-desktop-x-latest-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "vegito-debian-obs-vscode-golang-ai-dockerd-" {
  inherits = ["vegito-debian-obs-vscode-golang-ai-dockerd-base"]
  tags = [
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST,
    VEGITO_DOCKER_DEBIAN_OBS_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target-debian-golang-ai-dockerd-desktop-x"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_DEBIAN_OBS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_DEBIAN_OBS_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}
