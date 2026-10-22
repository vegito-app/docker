variable "VEGITO_DOCKER_PUBLIC_IMAGES_BASE_NAME" {
  default = "${VEGITO_DOCKER_PUBLIC_REPOSITORY}/vegito-docker"
}

variable "USE_REGISTRY_CACHE" {
  default = false
  type    = bool
}

variable "ENABLE_LOCAL_CACHE" {
  default = false
  type    = bool
}

variable "VEGITO_DOCKER_DIR" {
  default = "."
}

variable "VEGITO_DOCKER_BUILDX_LOCAL_CACHE_DIR" {
  default = "${VEGITO_DOCKER_DIR}/.containers/buildx-cache"
}

variable "VERSION" {
  description = "current git tag or commit version"
  default     = "dev"
}

variable "GO_VERSION" {
  description = "current Go version"
  default     = "1.27.2"
}

variable "NODE_VERSION" {
  description = "current Node version"
  default     = "22.22.0"
}

variable "OH_MY_ZSH_VERSION" {
  description = "current Oh My Zsh version"
  default     = "1.2.1"
}

variable "NVM_VERSION" {
  description = "current NVM version"
  default     = "0.40.1"
}

variable "DOCKER_VERSION" {
  description = "current Docker version"
  default     = "28.0.2"
}

variable "DOCKER_COMPOSE_VERSION" {
  description = "current Docker Compose version"
  default     = "2.34.0"
}

variable "DOCKER_BUILDX_VERSION" {
  description = "current Docker Buildx version"
  default     = "0.22.0"
}

variable "TERRAFORM_VERSION" {
  description = "current Terraform version"
  default     = "1.11.2"
}

variable "KUBECTL_VERSION" {
  description = "current Kubernetes version"
  default     = "1.32"
}

variable "K9S_VERSION" {
  description = "current K9S version"
  default     = "0.50.9"
}

variable "GITLEAKS_VERSION" {
  description = "current Gitleaks version"
  default     = "8.28.0"
}

variable "VEGITO_DOCKER_CACHE_REPOSITORY" {
  default = "vegito-docker-repository-cache"
}

variable "VEGITO_DOCKER_CACHE_IMAGES_BASE" {
  default = "${VEGITO_DOCKER_CACHE_REPOSITORY}/vegito-docker"
}

variable "VEGITO_DOCKER_PUBLIC_REPOSITORY" {
  default = "vegito-docker-repository-public"
}

variable "platforms" {
  default = [
    "linux/amd64",
    "linux/arm64",
  ]
}

variable "VEGITO_RELEASE_BUILD_MAX_PARALLELISM" {
  default = 2
}

# Groups are used to build incrementally the images in the correct order:
# - Dockerhub: the base images that we replicate to our private repository
# - Runners: the most basic level, they are used to run the services and applications
# - Builders: used to build the services, applications and the local development environments
# - Services: the dependencies of the applications, they are used to run the applications
# - Applications: the end products that we want to run and test
group "runners" {
  targets = [
    "vegito-debian",
  ]
}

group "runners-ci" {
  targets = [
    "vegito-debian-ci",
  ]
}

group "vegito-app-ci" {
  targets = [
    
    // Used by 
    // - vegito-app/caddy
    // - vegito-app/local/firebase-emulators
    // - vegito-app/local/vault-dev
    "vegito-trixie-debian-ci",

    // Used by 
    // - vegito-app/local/android/emulators
    "vegito-trixie-debian-desktop-x-ci",

    // Used by 
    // - vegito-app/local/android/emulators (flutter alternate)
    "vegito-trixie-debian-flutter-desktop-x-ci",
    
    // Used by vegito-app/caddy as Dockerfile builder
    "vegito-trixie-debian-golang-ci",

    // Used by vegito-app/local/robotframework as service base
    "vegito-debian-robotframework-ci",
    
    // Use as builder by vegito-app/local/clarinet-devnet
    "docker-rust-alpine-ci",

    // Used by vegito-app/ai as common AI service base
    "vegito-trixie-debian-desktop-x-project-obs-vscode-golang-ai-dockerd-ci",

    // Used as service runner by :
    // - vegito-app/jitsi
    // - vegito-app/mattermost
    // - vegito-app/local/clarinet-devnet
    "vegito-trixie-debian-dockerd-ci",

    // Used as image base
    // - vegito-app/example-application
    // - vegito-app/local
    // - vegito-app/vegito
    // - vegito-app/docker-ssh-bridge
    "vegito-trixie-debian-project-golang-docker-ci",

    // Used by Vegito vegito-app/payment project builder
    "vegito-trixie-debian-project-golang-docker-desktop-x-ci",

    // Used by Vegito vegito-app/payment project builder
    "vegito-trixie-debian-project-docker-ci",

    // Used by vegito-app/auth as Authentik service image base
    "vegito-trixie-debian-terraform-dockerd-ci",
  ]
}

group "default" {
  targets = [
    "release",
    "release-ci",
  ]
  pull            = true
  max_parallelism = VEGITO_RELEASE_BUILD_MAX_PARALLELISM
}

group "release" {
  targets = [
    "dockerhub",
    "runners",
  ]
}

group "release-ci" {
  targets = [
    "dockerhub-ci",
    "runners-ci"
  ]
}
