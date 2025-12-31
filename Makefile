.PHONY: help build run test fmt lint check docker-build docker-run clean

help:
	@echo "Unifi Protect MCP Server - Make Commands"
	@echo "========================================"
	@echo "  make build          - Build the protect MCP binary"
	@echo "  make run            - Run the protect MCP server"
	@echo "  make test           - Run tests"
	@echo "  make fmt            - Format code"
	@echo "  make lint           - Run linter"
	@echo "  make check          - Run all checks (fmt, lint, test)"
	@echo "  make docker-build   - Build Docker image"
	@echo "  make docker-run     - Run Docker container"
	@echo "  make clean          - Clean build artifacts"

build:
	go build -o bin/unifi-protect-mcp ./cmd

run: build
	./bin/unifi-protect-mcp

test:
	go test -v -cover ./...

fmt:
	go fmt ./...

lint:
	golangci-lint run ./...

check: fmt lint test

docker-build:
	docker build -t unifi-protect-mcp:latest .

docker-run: docker-build
	docker run --rm \
		-e UNIFI_PROTECT_URL="$${UNIFI_PROTECT_URL}" \
		-e UNIFI_PROTECT_USERNAME="$${UNIFI_PROTECT_USERNAME}" \
		-e UNIFI_PROTECT_PASSWORD="$${UNIFI_PROTECT_PASSWORD}" \
		unifi-protect-mcp:latest

clean:
	rm -rf bin/
	go clean
