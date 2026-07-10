variable "VEGITO_DOCKER_DEBIAN_PROJECT_KUBERNETES_DIR" {
  default = "${VEGITO_DOCKER_DEBIAN_DIR}/project-kubernetes"
}

target "vegito-debian-project-kubernetes-base" {
  context = VEGITO_DOCKER_DEBIAN_PROJECT_KUBERNETES_DIR
}
