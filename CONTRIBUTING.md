# Contributing to kaniko-image-builder

Thank you for your interest in contributing to the kaniko-image-builder project!

## Building Images

Use the provided build script to build Kaniko images:

```bash
# Build the latest version
./build.sh

# Build a specific version
./build.sh --version v1.19.0 --tag v1.19.0

# Build for a specific platform
./build.sh --version v1.19.0 --platform linux/arm64 --tag v1.19.0-arm64
```

### Build Script Options

```bash
./build.sh [OPTIONS]

OPTIONS:
    -v, --version VERSION   Kaniko version to build (tag, branch, or commit)
    -t, --tag TAG          Tag for the built images
    -r, --registry REG     Registry prefix for image names
    -p, --platform PLAT    Platform to build for
    --push                 Push images after building
    -h, --help             Show help message
```

## Building Manually

You can also build images directly with Docker:

```bash
# Build the executor image
docker build \
  --build-arg KANIKO_VERSION=v1.19.0 \
  --target kaniko-executor \
  -t kaniko-executor:v1.19.0 \
  .

# Build the warmer image
docker build \
  --build-arg KANIKO_VERSION=v1.19.0 \
  --target kaniko-warmer \
  -t kaniko-warmer:v1.19.0 \
  .
```

## Specifying Kaniko Versions

You can build any version from the Chainguard fork:

- **Specific tag**: `./build.sh --version v1.19.0`
- **Branch**: `./build.sh --version main`
- **Commit SHA**: `./build.sh --version abc123def456`
- **Latest**: `./build.sh` (default)

## Testing Changes

Before submitting a pull request:

1. Verify the Dockerfile builds successfully
2. Test the built images with example builds (see `examples/` directory)
3. Ensure the build script works as expected

## Updating the Kaniko Version

The images are built from the Chainguard fork of Kaniko at:
https://github.com/chainguard-forks/kaniko

To build a specific version, use the `--version` option with the build script.

## Multi-Architecture Builds

To build for different architectures, use the `--platform` option:

```bash
# Build for amd64 (default)
./build.sh --platform linux/amd64

# Build for arm64
./build.sh --platform linux/arm64
```

## Code of Conduct

Please be respectful and constructive in all interactions. We aim to foster an open and welcoming community.

## Questions?

If you have questions or need help, please open an issue on GitHub.
