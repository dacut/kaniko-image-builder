# Contributing to kaniko-image-builder

Thank you for your interest in contributing to the kaniko-image-builder project!

## Building Locally

To build the Kaniko images locally:

```bash
# Build the executor image
docker build -t kaniko-executor:local --target kaniko-executor .

# Build the warmer image
docker build -t kaniko-warmer:local --target kaniko-warmer .
```

### Build Arguments

You can specify a specific Kaniko version to build:

```bash
docker build \
  --build-arg KANIKO_VERSION=v1.19.0 \
  --target kaniko-executor \
  -t kaniko-executor:v1.19.0 \
  .
```

## Testing Changes

Before submitting a pull request, please:

1. Verify the Dockerfile builds successfully
2. Test the built images with example builds (see `examples/` directory)
3. Ensure the GitHub Actions workflow syntax is valid

## Updating the Kaniko Version

The images are built from the Chainguard fork of Kaniko at:
https://github.com/chainguard-forks/kaniko

To update the version:
1. Update the `KANIKO_VERSION` build argument (if needed)
2. Test the build locally
3. Submit a pull request with your changes

## GitHub Actions Workflow

The workflow builds images on:
- Pushes to the `main` branch
- Tag pushes (e.g., `v1.0.0`)
- Pull requests (build only, no push)
- Manual workflow dispatch

### Testing Workflow Changes

To test workflow changes:
1. Create a pull request - this will trigger a build without pushing images
2. Review the workflow run logs for any errors
3. Once approved and merged, images will be pushed to registries

## Multi-Architecture Builds

Images are built for:
- `linux/amd64`
- `linux/arm64`

The GitHub Actions workflow uses Docker Buildx for multi-platform builds.

## Code of Conduct

Please be respectful and constructive in all interactions. We aim to foster an open and welcoming community.

## Questions?

If you have questions or need help, please open an issue on GitHub.
