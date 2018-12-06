.PHONY: sync

STAGING_MONGO_URL ?= $(shell kubectl --context staging get configmap positron-environment -o json | jq -r '.data["MONGOHQ_URL"]')
PRODUCTION_MONGO_URL ?= $(shell kubectl --context production get configmap positron-environment -o json | jq -r '.data["MONGOHQ_URL"]')

sync:
	docker build -f sync/Dockerfile . -t artsy/positron_sync
	docker run \
		-e STAGING_MONGO_URL="$(STAGING_MONGO_URL)" \
		-e PRODUCTION_MONGO_URL="$(PRODUCTION_MONGO_URL)" \
		artsy/positron_sync:latest
