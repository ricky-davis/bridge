.PHONY: help bootstrap node-bootstrap run test fmt tidy build clean web-install web-dev web-build

GO := ./scripts/go
NPM := ./scripts/npm

NODE_VERSION ?= $(shell cat .node-version 2>/dev/null || echo "22.22.0")

help:
	@echo "Targets:"
	@echo "  bootstrap GO_VERSION=1.26.0        Download project-local Go into .tools/go"
	@echo "  node-bootstrap NODE_VERSION=$(NODE_VERSION)  Download project-local Node into .tools/node"
	@echo "  run                                 Run the Go server (serves frontend/dist if present)"
	@echo "  test                                Run unit tests"
	@echo "  fmt                                 Format code"
	@echo "  tidy                                go mod tidy"
	@echo "  web-install                         Install frontend deps (npm)"
	@echo "  web-dev                             Run Vite dev server (proxies to :8080)"
	@echo "  web-build                           Build frontend into frontend/dist"
	@echo "  build                               Build single binary with embedded frontend/dist"
	@echo "  clean                               Remove build outputs"

bootstrap:
	@if [ -z "$(GO_VERSION)" ]; then echo "GO_VERSION is required (e.g. GO_VERSION=1.26.0)"; exit 2; fi
	@./scripts/bootstrap-go.sh $(GO_VERSION)

node-bootstrap:
	@./scripts/bootstrap-node.sh $(NODE_VERSION)

run:
	@$(GO) run ./cmd/bridge

test:
	@$(GO) test ./...

fmt:
	@$(GO) fmt ./...

tidy:
	@$(GO) mod tidy

web-install:
	# Some environments default to omitting devDependencies (npm config omit=["dev"]).
	# We need dev deps for Vite/TypeScript builds.
	$(NPM) --prefix frontend install --include=dev

web-dev:
	$(NPM) --prefix frontend run dev

web-build:
	$(NPM) --prefix frontend run build

build: web-build
	@# Copy built UI into internal/web/dist for embedding (go:embed can't reference .. paths)
	@rm -rf internal/web/dist
	@mkdir -p internal/web/dist
	@cp -a frontend/dist/. internal/web/dist/
	@mkdir -p bin
	@$(GO) build -tags embed -o bin/bridge ./cmd/bridge

clean:
	@rm -rf bin internal/web/dist
