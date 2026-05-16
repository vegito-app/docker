
variable "FLUTTER_VERSION" {
  default = "3.41.0"
}

group "flutter-ci" {
  targets = [
    "flutter-version-ci",
    "flutter-latest-ci"
  ]
}

group "flutter-desktop-x-ci" {
  targets = [
    "flutter-desktop-x-version-ci",
    "flutter-desktop-x-latest-ci"
  ]
}

target "flutter-base" {
  args = {
    flutter_version = FLUTTER_VERSION
    non_root_user   = "flutter"
  }
  context = VEGITO_FLUTTER_DEBIAN_DIR
}

target "flutter-base-ci" {
  inherits  = ["flutter-base"]
  platforms = platforms
}

# -------------------------------------------------------------------
# ###################################################################
# LOCAL FLUTTER DEBIAN
# ###################################################################
variable "VEGITO_FLUTTER_DEBIAN_DIR" {
  default = "${VEGITO_DOCKER_DIR}/flutter"
}

variable "VEGITO_FLUTTER_DEBIAN_REGISTRY_CACHE_IMAGE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/flutter"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/flutter"
}
variable "VEGITO_FLUTTER_DEBIAN_VERSION" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:flutter-${VERSION}"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_LATEST" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:flutter-latest"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/flutter-version"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/flutter-latest"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version) for flutter image build"
  default     = "type=local,mode=max,dest=${VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest) for flutter image build"
  default     = "type=local,mode=max,dest=${VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

target "flutter-latest-ci" {
  inherits = ["flutter-base"]
  contexts = {
    debian = "target:debian-latest-ci"
  }
  tags = [
    VEGITO_FLUTTER_DEBIAN_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      "type=inline,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "flutter-version-ci" {
  inherits = ["flutter-base-ci"]
  contexts = {
    debian = "target:debian-version-ci"
  }
  tags = [
    VEGITO_FLUTTER_DEBIAN_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      "type=inline,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
}

target "flutter-debian" {
  inherits = ["flutter-base"]
  contexts = {
    debian = "target:debian"
  }
  tags = [
    VEGITO_FLUTTER_DEBIAN_IMAGE_LATEST,
    VEGITO_FLUTTER_DEBIAN_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      "type=inline,ref=${VEGITO_FLUTTER_DEBIAN_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DEBIAN_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}

# -------------------------------------------------------------------
# ###################################################################
# Desktop X
# ###################################################################
variable "VEGITO_FLUTTER_DESKTOP_X_REGISTRY_CACHE_IMAGE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/flutter-desktop-x"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/flutter-desktop-x"
}

variable "VEGITO_FLUTTER_DESKTOP_X_VERSION" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:flutter-desktop-x-${VERSION}"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_LATEST" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:flutter-desktop-x-latest"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/flutter-desktop-x-version"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/flutter-desktop-x-latest"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache (version) for flutter image build"
  default     = "type=local,mode=max,dest=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache (latest) for flutter image build"
  default     = "type=local,mode=max,dest=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION" {
  description = "local read cache (version)"
  default     = "type=local,src=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_VERSION}"
}

variable "VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST" {
  description = "local read cache (latest)"
  default     = "type=local,src=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_LATEST}"
}

target "flutter-desktop-x-latest-ci" {
  inherits = ["flutter-base-ci"]
  contexts = {
    debian = "target:local-desktop-x-latest-ci"
  }
  args = {
    user = "desktopx"
  }
  tags = [
    VEGITO_FLUTTER_DESKTOP_X_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      "type=inline,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
}

target "flutter-desktop-x-version-ci" {
  inherits = ["flutter-base-ci"]
  contexts = {
    debian = "target:local-desktop-x-version-ci"
  }
  args = {
    user = "desktopx"
  }
  tags = [
    VEGITO_FLUTTER_DESKTOP_X_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_VERSION
    ] : [],
    [
      "type=inline,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : []
  )
}

target "flutter-desktop-x" {
  contexts = {
    debian = "target:local-desktop-x"
  }
  args = {
    user = "desktopx"
  }
  tags = [
    VEGITO_FLUTTER_DESKTOP_X_IMAGE_LATEST,
    VEGITO_FLUTTER_DESKTOP_X_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_REGISTRY_CACHE}",
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ_LATEST
    ] : [],
    [
      "type=inline,ref=${VEGITO_FLUTTER_DESKTOP_X_IMAGE_LATEST}",
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_FLUTTER_DESKTOP_X_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}
