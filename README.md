# kaniko-image-builder

Build Docker images for [Kaniko](https://github.com/GoogleContainerTools/kaniko) from the [Chainguard fork](https://github.com/chainguard-forks/kaniko).

## Overview

This repository provides a Dockerfile and build script to create Kaniko executor and warmer images from the Chainguard fork.

## Quick Start

Build the latest version:

```bash
./build.sh
```

Build a specific tag:

```bash
./build.sh --version v1.19.0 --tag v1.19.0
```

Build a specific commit:

```bash
./build.sh --version abc123def --tag mycommit
```

## Build Script Usage

The `build.sh` script provides a convenient way to build Kaniko images with various options:

```bash
./build.sh [OPTIONS]

OPTIONS:
    -v, --version VERSION   Kaniko version to build (tag, branch, or commit)
                           Default: latest
    -t, --tag TAG          Tag for the built images
                           Default: latest
    -r, --registry REG     Registry prefix for image names
                           Default: local (no registry prefix)
    -p, --platform PLAT    Platform to build for (e.g., linux/amd64, linux/arm64)
                           Default: linux/amd64
    --push                 Push images after building
    -h, --help             Show this help message
```

### Examples

```bash
# Build latest version
./build.sh

# Build a specific Kaniko version with a custom tag
./build.sh --version v1.19.0 --tag v1.19.0

# Build for arm64
./build.sh --version v1.19.0 --platform linux/arm64 --tag v1.19.0-arm64

# Build and push to a registry
./build.sh --registry ghcr.io/myuser --tag latest --push

# Build a specific commit
./build.sh --version 6f6a3bcf9a8c --tag dev-6f6a3bc
```

## Images Built

The build script creates two images:

### Kaniko Executor
The main Kaniko image for building container images.

**Default name:** `kaniko-executor:latest`

### Kaniko Warmer
A utility for pre-warming the Kaniko cache with base images.

**Default name:** `kaniko-warmer:latest`

## Building Manually with Docker

You can also build the images directly using Docker:

```bash
# Build executor
docker build \
  --build-arg KANIKO_VERSION=v1.19.0 \
  --target kaniko-executor \
  -t kaniko-executor:v1.19.0 \
  .

# Build warmer
docker build \
  --build-arg KANIKO_VERSION=v1.19.0 \
  --target kaniko-warmer \
  -t kaniko-warmer:v1.19.0 \
  .
```

### Build Arguments

- `KANIKO_VERSION`: The tag, branch, or commit SHA to build from the Chainguard fork (default: `latest`)

## Using the Built Images

### Using the Kaniko Executor

```bash
# Build an image without pushing
docker run -v "$(pwd)":/workspace \
  kaniko-executor:latest \
  --dockerfile=/workspace/Dockerfile \
  --context=/workspace \
  --destination=my-image:latest \
  --no-push

# Build and push to a registry
docker run -v "$(pwd)":/workspace \
  -v ~/.docker/config.json:/kaniko/.docker/config.json:ro \
  kaniko-executor:latest \
  --dockerfile=/workspace/Dockerfile \
  --context=/workspace \
  --destination=myregistry/my-image:latest
```

### Using the Kaniko Warmer

```bash
# Pre-warm cache with a base image
docker run -v "$(pwd)/cache":/cache \
  kaniko-warmer:latest \
  --cache-dir=/cache \
  --image=alpine:latest
```

## Features

- **Multi-architecture support**: Build for `linux/amd64` or `linux/arm64`
- **Credential helpers**: Includes support for GCR, ECR, and ACR
- **Minimal footprint**: Uses scratch-based images for security and size
- **Flexible versioning**: Build any version (tag, branch, or commit) from the Chainguard fork

## Examples

See the `examples/` directory for sample usage with Docker and Kubernetes.

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

## About Kaniko

Kaniko is a tool to build container images from a Dockerfile inside a container or Kubernetes cluster without requiring privileged access. This makes it ideal for CI/CD pipelines and secure build environments.

## Credits

- [Kaniko](https://github.com/GoogleContainerTools/kaniko) - Google Container Tools
- [Chainguard Kaniko Fork](https://github.com/chainguard-forks/kaniko) - Chainguard's maintained fork
