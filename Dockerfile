# Build Kaniko from the Chainguard fork
FROM golang:1.21-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make bash

# Set working directory
WORKDIR /workspace

# Clone the Chainguard fork of Kaniko
ARG KANIKO_VERSION=latest
RUN git clone https://github.com/chainguard-forks/kaniko.git . && \
    if [ "$KANIKO_VERSION" != "latest" ]; then \
        git checkout "$KANIKO_VERSION"; \
    fi

# Build the executor binary
RUN make

# Create minimal runtime image
FROM gcr.io/distroless/static:nonroot

# Copy the executor binary from builder
COPY --from=builder /workspace/out/executor /kaniko/executor

# Set the entry point
ENTRYPOINT ["/kaniko/executor"]
