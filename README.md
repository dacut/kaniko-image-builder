# kaniko-image-builder

Build Docker images for [Kaniko](https://github.com/GoogleContainerTools/kaniko) from the [Chainguard fork](https://github.com/chainguard-forks/kaniko).

## Overview

This repository builds and publishes Kaniko executor and warmer images to multiple container registries:
- Docker Hub
- GitHub Container Registry (ghcr.io)
- Amazon ECR Public

## Images Available

Two image types are built:

### Kaniko Executor
The main Kaniko image for building container images.

### Kaniko Warmer
A utility for pre-warming the Kaniko cache with base images.

## Image Registries

The built images are available at:

### Executor Images
- **Docker Hub**: `<username>/kaniko-executor:latest`
- **GitHub Container Registry**: `ghcr.io/dacut/kaniko-executor:latest`
- **Amazon ECR Public**: `public.ecr.aws/<alias>/kaniko-executor:latest`

### Warmer Images
- **Docker Hub**: `<username>/kaniko-warmer:latest`
- **GitHub Container Registry**: `ghcr.io/dacut/kaniko-warmer:latest`
- **Amazon ECR Public**: `public.ecr.aws/<alias>/kaniko-warmer:latest`

## Usage

### Using the Kaniko Executor

```bash
# Pull from Docker Hub
docker pull <username>/kaniko-executor:latest

# Pull from GitHub Container Registry
docker pull ghcr.io/dacut/kaniko-executor:latest

# Pull from Amazon ECR Public
docker pull public.ecr.aws/<alias>/kaniko-executor:latest
```

### Building Images with Kaniko

```bash
docker run -v $(pwd):/workspace \
  ghcr.io/dacut/kaniko-executor:latest \
  --dockerfile=/workspace/Dockerfile \
  --context=/workspace \
  --destination=myrepo/myimage:latest
```

### Using the Kaniko Warmer

```bash
# Pre-warm cache with a base image
docker run -v $(pwd)/cache:/cache \
  ghcr.io/dacut/kaniko-warmer:latest \
  --cache-dir=/cache \
  --image=alpine:latest
```

## Building Locally

To build the Kaniko images locally:

```bash
# Build executor
docker build -t kaniko-executor:local --target kaniko-executor .

# Build warmer
docker build -t kaniko-warmer:local --target kaniko-warmer .
```

To build a specific version of Kaniko:

```bash
docker build -t kaniko-executor:v1.19.0 \
  --build-arg KANIKO_VERSION=v1.19.0 \
  --target kaniko-executor .
```

## Features

- **Multi-architecture support**: Builds for `linux/amd64` and `linux/arm64`
- **Credential helpers**: Includes support for GCR, ECR, and ACR
- **Minimal footprint**: Uses scratch-based images for security and size
- **Flexible versioning**: Build any version from the Chainguard fork

## GitHub Actions Workflow

The repository includes a GitHub Actions workflow that automatically builds and publishes images:

- **On push to main**: Builds and pushes images tagged as `latest`
- **On tag push (v*)**: Builds and pushes versioned images
- **On pull request**: Builds images without pushing (for testing)
- **Manual trigger**: Allows building specific Kaniko versions

### Required Secrets

Configure the following secrets in your GitHub repository:

#### Docker Hub (Optional)
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token

#### Amazon ECR Public (Optional)
- `AWS_ACCESS_KEY_ID`: AWS access key with ECR public permissions
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `ECR_ALIAS`: Your ECR public registry alias

#### GitHub Container Registry
- Uses the built-in `GITHUB_TOKEN` (no additional configuration needed)

**Note**: The workflow will continue even if some registries are not configured, ensuring at least GitHub Container Registry publishes succeed.

## Multi-Architecture Support

The workflow builds images for multiple architectures:
- `linux/amd64`
- `linux/arm64`

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.

## About Kaniko

Kaniko is a tool to build container images from a Dockerfile inside a container or Kubernetes cluster without requiring privileged access. This makes it ideal for CI/CD pipelines and secure build environments.

## Credits

- [Kaniko](https://github.com/GoogleContainerTools/kaniko) - Google Container Tools
- [Chainguard Kaniko Fork](https://github.com/chainguard-forks/kaniko) - Chainguard's maintained fork
