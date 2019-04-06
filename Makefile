GO ?= go
GO_ON ?= GO111MODULE=on go
GO_OFF ?= GO111MODULE=off go
GOFMT ?= gofmt "-s"
PACKAGES ?= $(shell GO111MODULE=on $(GO) list ./...)
VETPACKAGES ?= $(shell GO111MODULE=on $(GO) list ./...)
GOFILES := $(shell find . -name "*.go" -type f)

LDFLAGS += -X "github.com/krmall/krmall/version.BuildTime=$(shell date -u '+%Y-%m-%d %I:%M:%S %Z')"
LDFLAGS += -X "github.com/krmall/krmall/version.GitHash=$(shell git rev-parse HEAD)"

TAGS = release
TAGET_APP = krmall
ASSETS_DATA_FILES := $(shell find assets | sed 's/  /\\ /g')

.PHONY: default
default: build

.PHONY: ci
ci: misspell lint vet test

.PHONY: build
build: fmt generate
	$(GO_ON) build -ldflags '$(LDFLAGS)' -tags '$(TAGS)' -o $(TAGET_APP) github.com/krmall/krmall

.PHONY: serve
serve: fmt generate
	$(GO_ON) run -ldflags '$(LDFLAGS)' -tags '$(TAGS)' github.com/krmall/krmall serve --debug

.PHONY: test
test:
	$(GO_ON) test -race ./...

.PHONY: fmt
fmt:
	$(GOFMT) -w $(GOFILES)

.PHONY: fmt-check
fmt-check:
	@diff=$$($(GOFMT) -d $(GOFILES)); \
	if [ -n "$$diff" ]; then \
		echo "Please run 'make fmt' and commit the result:"; \
		echo "$${diff}"; \
		exit 1; \
	fi;

.PHONY: vet
vet:
	$(GO_ON) vet $(VETPACKAGES)

.PHONY: lint
lint:
	@hash golint > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		$(GO_OFF) get -u golang.org/x/lint/golint; \
	fi
	for PKG in $(PACKAGES); do golint -min_confidence 1.0 -set_exit_status $$PKG || exit 1; done;

.PHONY: misspell-check
misspell-check:
	@hash misspell > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		$(GO_OFF) get -u github.com/client9/misspell/cmd/misspell; \
	fi
	misspell -error $(GOFILES)

.PHONY: misspell
misspell:
	@hash misspell > /dev/null 2>&1; if [ $$? -ne 0 ]; then \
		$(GO_OFF) get -u github.com/client9/misspell/cmd/misspell; \
	fi
	misspell -w $(GOFILES)

.PHONY: generate
generate: $(ASSETS_DATA_FILES)
	-rm -f pkg/assets/assets_gen.go
	go generate pkg/assets/assets.go
	gofmt -s -w pkg/assets

.PHONY: api
api:
	docker run -it --rm -p 8080:80 -v $(PWD)/api/openapi.yaml:/usr/share/nginx/html/openapi.yaml -e SPEC_URL=openapi.yaml redocly/redoc

.PHONY: clean
clean:
	$(GO_ON) clean -r ./...
	rm -f krmall

.PHONY: tools
tools:
	$(GO_OFF) get golang.org/x/lint/golint
	$(GO_OFF) get github.com/client9/misspell/cmd/misspell
