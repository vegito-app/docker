variable "VEGITO_DEBIAN_VERSION" {
  default = "${VEGITO_PUBLIC_IMAGES_BASE_NAME}:debian-${VERSION}"
}

variable "VEGITO_DEBIAN_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/debian"
}

variable "VEGITO_DEBIAN_DIR" {
  default = "${VEGITO_DOCKER_DIR}/debian"
}

variable "VEGITO_DEBIAN_IMAGE_REGISTRY_CACHE" {
  default = "${VEGITO_CACHE_IMAGES_BASE}/debian"
}

variable "VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/debian"
}

variable "VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DEBIAN_IMAGE_LATEST" {
  default = "${VEGITO_PRIVATE_REPOSITORY}/debian:latest"
}

variable "VEGITO_DEBIAN_IMAGE_VERSION" {
  default = "${VEGITO_PRIVATE_REPOSITORY}/debian:${VERSION}"
}

group "debian-ci" {
  targets = [
    "debian-version-ci",
    "debian-latest-ci",
  ]
}

target "debian-version-ci" {
  tags = [
    VEGITO_DEBIAN_IMAGE_VERSION,
  ]
  context = VEGITO_DEBIAN_DIR
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      "type=inline,ref=${VEGITO_DEBIAN_IMAGE_LATEST}"
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "debian-latest-ci" {
  tags = [
    VEGITO_DEBIAN_IMAGE_LATEST,
  ]
  context = VEGITO_DEBIAN_DIR
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      "type=inline,ref=${VEGITO_DEBIAN_IMAGE_LATEST}"
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DEBIAN_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "debian" {
  tags = [
    VEGITO_DEBIAN_IMAGE_LATEST,
  ]
  context = VEGITO_DEBIAN_DIR
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DEBIAN_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      "type=inline,ref=${VEGITO_DEBIAN_IMAGE_LATEST}"
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}

variable "VEGITO_DEBIAN_PYTHON_IMAGE_LATEST" {
  default = "${VEGITO_PRIVATE_REPOSITORY}/python:latest"
}

variable "VEGITO_DEBIAN_PYTHON_IMAGE_VERSION" {
  default = "${VEGITO_PRIVATE_REPOSITORY}/python:${VERSION}"
}

variable "VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE" {
  default = "${VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR}/python"
}

variable "VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE" {
  default = "type=local,mode=max,dest=${VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

variable "VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ" {
  default = "type=local,src=${VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE}"
}

group "python-debian-ci" {
  targets = [
    "python-debian-version-ci",
    "python-debian-latest-ci",
  ]
}

target "python-debian-version-ci" {
  tags = [
    VEGITO_DEBIAN_PYTHON_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:debian-version-ci"
  }
  context    = VEGITO_DEBIAN_DIR
  dockerfile = "python.Dockerfile"
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      "type=inline,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_LATEST}"
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : [],
  )
  platforms = platforms
}

target "python-debian-latest-ci" {
  tags = [
    VEGITO_DEBIAN_PYTHON_IMAGE_LATEST,
  ]
  contexts = {
    debian = "target:debian-latest-ci"
  }
  context    = VEGITO_DEBIAN_DIR
  dockerfile = "python.Dockerfile"
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      "type=inline,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_LATEST}"
    ]
  )
  cache-to = [
    USE_REGISTRY_CACHE ? "type=registry,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_REGISTRY_CACHE},mode=max" : "",
    "type=inline"
  ]
  platforms = platforms
}

target "python" {
  tags = [
    VEGITO_DEBIAN_PYTHON_IMAGE_LATEST,
    VEGITO_DEBIAN_PYTHON_IMAGE_VERSION,
  ]
  contexts = {
    debian = "target:debian"
  }
  context    = VEGITO_DEBIAN_DIR
  dockerfile = "python.Dockerfile"
  cache-from = concat(
    USE_REGISTRY_CACHE ? [
      "type=registry,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_REGISTRY_CACHE}"
    ] : [],
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_READ
    ] : [],
    [
      "type=inline,ref=${VEGITO_DEBIAN_PYTHON_IMAGE_LATEST}"
    ]
  )
  cache-to = concat(
    ENABLE_LOCAL_CACHE ? [
      VEGITO_DEBIAN_PYTHON_IMAGE_DOCKER_BUILDX_LOCAL_CACHE_WRITE
    ] : []
  )
}
