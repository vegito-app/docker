variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/git"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}-git"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/trixie-debian-git:latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/trixie-debian-git:${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}-git"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}


group "vegito-trixie-debian-git" {
  targets = [
    "vegito-trixie-debian-git-version",
    "vegito-trixie-debian-git-latest",
    "vegito-trixie-debian-git-desktop-x-version",
    "vegito-trixie-debian-git-desktop-x-latest",
    "vegito-trixie-debian-git-dockerd-desktop-x-version",
    "vegito-trixie-debian-git-dockerd-desktop-x-latest",
  ]
}
group "vegito-trixie-debian-git-ci" {
  targets = [
    "vegito-trixie-debian-git-version-ci",
    "vegito-trixie-debian-git-latest-ci",

    "vegito-trixie-debian-git-desktop-x-ci",

    "vegito-trixie-debian-git-dockerd-desktop-x-ci",
  ]
}

group "vegito-trixie-debian-git-desktop-x-ci" {
  targets = [
    "vegito-trixie-debian-git-desktop-x-version-ci",
    "vegito-trixie-debian-git-desktop-x-latest-ci",
  ]
}

group "vegito-trixie-debian-git-dockerd-desktop-x-ci" {
  targets = [
    "vegito-trixie-debian-git-dockerd-desktop-x-version-ci",
    "vegito-trixie-debian-git-dockerd-desktop-x-latest-ci",
  ]
}

target "vegito-trixie-debian-git-base" {
  context = VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DIR
  args = {
    debian_version = "trixie"
  }
}

target "vegito-trixie-debian-git-version-ci" {
  inherits = ["vegito-trixie-debian-git-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-version-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "vegito-trixie-debian-git-latest-ci" {
  inherits = ["vegito-trixie-debian-git-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_LATEST,
  ]
  contexts = {
    debian = "target:vegito-trixie-debian-latest-ci"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_LATEST
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "vegito-trixie-debian-git" {
  inherits = ["vegito-trixie-debian-git-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:debian"
  }
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-git-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-git-desktop-x-latest"
}
variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}-git"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_IMAGE_REGISTRY_CACHE}-git-desktop-x"
}

target "vegito-trixie-debian-git-desktop-x-version-ci" {
  contexts = {
    debian = "target:vegito-trixie-debian-desktop-x-version-ci"
  }
  inherits = ["vegito-trixie-debian-git-base"]
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "vegito-trixie-debian-git-desktop-x-latest-ci" {
  inherits = ["vegito-trixie-debian-git-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "vegito-trixie-debian-git-desktop-x" {
  inherits = ["vegito-trixie-debian-git-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-desktop-x-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_VERSION,
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DOCKER_DESKTOP_X_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-docker-git-desktop-x-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DOCKER_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:trixie-debian-docker-git-desktop-x-latest"
}

target "vegito-trixie-debian-git-dockerd-desktop-x-version-ci" {
  inherits = ["vegito-trixie-debian-git-desktop-x-version-ci"]
  contexts = {
    debian = "target:vegito-trixie-debian-docker-desktop-x-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DOCKER_DESKTOP_X_IMAGE_VERSION,
  ]
}

target "vegito-trixie-debian-git-dockerd-desktop-x-latest-ci" {
  inherits = ["vegito-trixie-debian-git-desktop-x-latest-ci"]
  contexts = {
    debian = "target:vegito-trixie-debian-docker-desktop-x-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DOCKER_DESKTOP_X_IMAGE_LATEST,
  ]
}

target "vegito-trixie-debian-git-dockerd-desktop-x" {
  inherits = ["vegito-trixie-debian-git-desktop-x"]
  contexts = {
    debian = "target:vegito-trixie-debian-docker-desktop-x"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DOCKER_DESKTOP_X_IMAGE_LATEST,
    VEGITO_DOCKER_TRIXIE_DEBIAN_GIT_DOCKER_DESKTOP_X_IMAGE_VERSION,
  ]
}
