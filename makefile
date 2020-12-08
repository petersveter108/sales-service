SHELL := /bin/bash

# ==============================================================================
# Building containers

all: sales-api

sales-api:
	docker build \
		-f zarf/docker/dockerfile.sales-api \
		-t sales-api-amd64:1.0 \
		--build-arg VCS_REF=`git rev-parse HEAD` \
		--build-arg BUILD_DATE=`date -u +”%Y-%m-%dT%H:%M:%SZ”` \
		.

# ==============================================================================
# Running from within k8s/dev

kind-up:
	kind create cluster --image kindest/node:v1.19.4 --name peter-starter-cluster --config zarf/k8s/dev/kind-config.yaml

kind-down:
	kind delete cluster --name peter-starter-cluster

kind-load:
	kind load docker-image sales-api-amd64:1.0 --name peter-starter-cluster

kind-services:
	kustomize build zarf/k8s/dev | kubectl apply -f -

kind-update: sales-api
	kind load docker-image sales-api-amd64:1.0 --name peter-starter-cluster
	kubectl delete pods -lapp=sales-api

#kind-metrics: metrics
#	kind load docker-image metrics-amd64:1.0 --name peter-starter-cluster
#	kubectl delete pods -lapp=sales-api

kind-logs:
	kubectl logs -lapp=sales-api --all-containers=true -f

kind-status:
	kubectl get nodes
	kubectl get pods --watch

kind-status-full:
	kubectl describe pod -lapp=sales-api

#kind-shell:
#	kubectl exec -it $(shell kubectl get pods | grep sales-api | cut -c1-26) --container app -- /bin/sh
#
#kind-database:
#	# ./admin --db-disable-tls=1 migrate
#	# ./admin --db-disable-tls=1 seed
#
#kind-delete:
#	kustomize build zarf/k8s/dev | kubectl delete -f -

# ==============================================================================

run:
	go run app/sales-api/main.go

test:
	go test -v ./... -count=1
	staticcheck ./...

tidy:
	go mod tidy
	go mod vendor
