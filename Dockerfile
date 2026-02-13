# Build Kaniko from the Chainguard fork
FROM golang:1.22-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git make bash ca-certificates

# Set working directory
WORKDIR /src

# Clone the Chainguard fork of Kaniko
ARG KANIKO_VERSION=latest
RUN git clone https://github.com/chainguard-forks/kaniko.git . && \
    if [ "$KANIKO_VERSION" != "latest" ]; then \
        git checkout "$KANIKO_VERSION"; \
    fi

# Set up Go environment
ENV CGO_ENABLED=0
ENV GOBIN=/usr/local/bin

# Add .docker config dir
RUN mkdir -p /kaniko/.docker

# Install credential helpers
# Note: Versions are controlled by the Kaniko repository's go.mod
RUN go install github.com/GoogleCloudPlatform/docker-credential-gcr/v2 && \
    go install github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login && \
    go install github.com/chrismellard/docker-credential-acr-env

# Build the executor and warmer binaries
RUN make out/executor out/warmer

# Use busybox for base utilities
FROM busybox:musl AS busybox

# Create base slim image
FROM scratch AS kaniko-base-slim

# Create kaniko directory with write permissions
RUN --mount=from=busybox,dst=/usr/ ["busybox", "sh", "-c", "mkdir -p /kaniko && chmod 777 /kaniko"]

# Copy CA certificates
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /kaniko/ssl/certs/

# Copy nsswitch.conf
COPY files/nsswitch.conf /etc/nsswitch.conf

# Set environment
ENV HOME=/root
ENV USER=root
ENV PATH=/usr/local/bin:/kaniko
ENV SSL_CERT_DIR=/kaniko/ssl/certs

# Create full base image with credential helpers
FROM kaniko-base-slim AS kaniko-base

COPY --from=builder --chown=0:0 /usr/local/bin/docker-credential-gcr /kaniko/docker-credential-gcr
COPY --from=builder --chown=0:0 /usr/local/bin/docker-credential-ecr-login /kaniko/docker-credential-ecr-login
COPY --from=builder --chown=0:0 /usr/local/bin/docker-credential-acr-env /kaniko/docker-credential-acr-env
COPY --from=builder /kaniko/.docker /kaniko/.docker

ENV DOCKER_CONFIG=/kaniko/.docker/
ENV DOCKER_CREDENTIAL_GCR_CONFIG=/kaniko/.config/gcloud/docker_credential_gcr_config.json
WORKDIR /workspace

# Create executor image
FROM kaniko-base AS kaniko-executor

COPY --from=builder /src/out/executor /kaniko/executor

ENTRYPOINT ["/kaniko/executor"]

# Create warmer image
FROM kaniko-base AS kaniko-warmer

COPY --from=builder /src/out/warmer /kaniko/warmer

ENTRYPOINT ["/kaniko/warmer"]
