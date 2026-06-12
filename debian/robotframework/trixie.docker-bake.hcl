variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGES_BASE" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:robotframework"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_VERSION" {
  default = "${VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME}:robotframework-${VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_LATEST" {
  default = "${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGES_BASE}-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_DOCKER_CACHE_IMAGES_BASE}/robotframework"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_VERSION" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/robotframework-version"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_LATEST" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/robotframework-latest"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION" {
  description = "local write cache for clarinet image build (version)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST" {
  description = "local write cache for clarinet image build (latest)"
  default     = "type=local,mode=max,dest=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_LATEST}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_READ_VERSION" {
  description = "local read cache for clarinet image build (version)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_VERSION}"
}

variable "VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_READ_LATEST" {
  description = "local read cache for clarinet image build (latest)"
  default     = "type=local,src=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_LATEST}"
}

group "vegito-trixie-debian-robotframework-ci" {
  targets = [
    "vegito-trixie-debian-robotframework-version-ci",
    "vegito-trixie-debian-robotframework-latest-ci",
  ]
}

target "vegito-trixie-debian-robotframework-base" {
  inherits = ["vegito-debian-robotframework-base"]
  args = {
    debian_version = "trixie"
  }
}

target "vegito-trixie-debian-robotframework-version-ci" {
  inherits = ["vegito-trixie-debian-robotframework-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-python-version-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_VERSION,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_READ_VERSION
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_READ_VERSION
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_CACHE_WRITE_VERSION
    ] : [],
  )
  platforms = platforms
}

target "vegito-trixie-debian-robotframework-latest-ci" {
  inherits = ["vegito-trixie-debian-robotframework-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-python-latest-ci"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_REGISTRY_CACHE},mode=max"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : [],
    [
      "type=inline"
    ]
  )
  platforms = platforms
}

target "vegito-trixie-debian-robotframework" {
  inherits = ["vegito-trixie-debian-robotframework-base"]
  contexts = {
    debian = "target:vegito-trixie-debian-python"
  }
  tags = [
    VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_VERSION,
    VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_LATEST,
  ]
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_VEGITO_DOCKER_CACHE_READ_LATEST
    ] : [],
    [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_TESTS_IMAGE_LATEST
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DOCKER_TRIXIE_DEBIAN_ROBOTFRAMEWORK_IMAGE_DOCKER_BUILDX_CACHE_WRITE_LATEST
    ] : []
  )
}
