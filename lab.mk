VEGITO_LAB_DOCKER_REGISTRIES ?= public private cache 

vegito-lab-docker-login: $(VEGITO_LAB_DOCKER_REGISTRIES:%=vegito-lab-%-docker-login)
	@echo "Logged into Vegito lab Docker registry internally not required"
.PHONY: vegito-lab-docker-login

$(VEGITO_LAB_DOCKER_REGISTRIES:%=vegito-lab-%-docker-login):
	@echo "Logging into Vegito lab '$(@:vegito-lab-%-docker-login=%)' Docker registry internally not required"
#	@printf '%s' "$$VEGITO_LAB_REGISTRY_PASSWORD" | docker login registry-$(@:vegito-lab-%-docker-login=%).vegito.app \
	  --username "$$VEGITO_LAB_REGISTRY_USERNAME" \
	  --password-stdin
.PHONY: $(VEGITO_LAB_DOCKER_REGISTRIES:%=vegito-lab-%-docker-login)

export VEGITO_LAB_REGISTRY_PUBLIC ?= registry-public.vegito.app
export VEGITO_LAB_REGISTRY_PRIVATE ?= registry-private.vegito.app
export VEGITO_LAB_REGISTRY_CACHE ?= registry-cache.vegito.app

VEGITO_LAB_REGISTRY_USERNAME ?= $(VEGITO_LAB_REGISTRY_USERNAME)
VEGITO_LAB_REGISTRY_PASSWORD  ?= $(VEGITO_LAB_REGISTRY_PASSWORD)

