# kaniko-image-builder

Build Docker images for [Kaniko](https://github.com/GoogleContainerTools/kaniko) from the [Chainguard fork](https://github.com/chainguard-forks/kaniko).

## Overview

This repository builds and publishes Kaniko executor images to multiple container registries:
- Docker Hub
- GitHub Container Registry (ghcr.io)
- Amazon ECR Public

## Image Registries

The built images are available at:
- **Docker Hub**: `<username>/kaniko-executor:latest`
- **GitHub Container Registry**: `ghcr.io/dacut/kaniko-executor:latest`
- **Amazon ECR Public**: `public.ecr.aws/<alias>/kaniko-executor:latest`

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

## Building Locally

To build the Kaniko image locally:

```bash
docker build -t kaniko-executor:local .
```

To build a specific version of Kaniko:

```bash
docker build -t kaniko-executor:v1.19.0 --build-arg KANIKO_VERSION=v1.19.0 .
```

## GitHub Actions Workflow

The repository includes a GitHub Actions workflow that automatically builds and publishes images:

- **On push to main**: Builds and pushes images tagged as `latest`
- **On tag push (v*)**: Builds and pushes versioned images
- **On pull request**: Builds images without pushing
- **Manual trigger**: Allows building specific Kaniko versions

### Required Secrets

Configure the following secrets in your GitHub repository:

#### Docker Hub
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Docker Hub access token

#### Amazon ECR Public
- `AWS_ACCESS_KEY_ID`: AWS access key with ECR public permissions
- `AWS_SECRET_ACCESS_KEY`: AWS secret access key
- `ECR_ALIAS`: Your ECR public registry alias

#### GitHub Container Registry
- Uses the built-in `GITHUB_TOKEN` (no additional configuration needed)

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
