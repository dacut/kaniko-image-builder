#!/bin/bash
# Build Kaniko executor and warmer images from the Chainguard fork

set -e

# Default values
KANIKO_VERSION="${KANIKO_VERSION:-latest}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
REGISTRY="${REGISTRY:-local}"
PLATFORM="${PLATFORM:-linux/amd64}"
PUSH="${PUSH:-false}"

# Display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Build Kaniko executor and warmer images from the Chainguard fork.

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

EXAMPLES:
    # Build latest version
    $0

    # Build a specific tag
    $0 --version v1.19.0 --tag v1.19.0

    # Build a specific commit
    $0 --version abc123def --tag abc123def

    # Build for arm64
    $0 --platform linux/arm64

    # Build and push to a registry
    $0 --registry ghcr.io/myuser --tag latest --push

EOF
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            KANIKO_VERSION="$2"
            shift 2
            ;;
        -t|--tag)
            IMAGE_TAG="$2"
            shift 2
            ;;
        -r|--registry)
            REGISTRY="$2"
            shift 2
            ;;
        -p|--platform)
            PLATFORM="$2"
            shift 2
            ;;
        --push)
            PUSH="true"
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option $1"
            usage
            ;;
    esac
done

# Construct image names
if [ "$REGISTRY" = "local" ]; then
    EXECUTOR_IMAGE="kaniko-executor:${IMAGE_TAG}"
    WARMER_IMAGE="kaniko-warmer:${IMAGE_TAG}"
else
    EXECUTOR_IMAGE="${REGISTRY}/kaniko-executor:${IMAGE_TAG}"
    WARMER_IMAGE="${REGISTRY}/kaniko-warmer:${IMAGE_TAG}"
fi

echo "========================================="
echo "Building Kaniko Images"
echo "========================================="
echo "Kaniko version: $KANIKO_VERSION"
echo "Image tag:      $IMAGE_TAG"
echo "Platform:       $PLATFORM"
echo "Executor:       $EXECUTOR_IMAGE"
echo "Warmer:         $WARMER_IMAGE"
echo "Push:           $PUSH"
echo "========================================="

# Build executor image
echo ""
echo "Building executor image..."
docker build \
    --platform="$PLATFORM" \
    --build-arg KANIKO_VERSION="$KANIKO_VERSION" \
    --target kaniko-executor \
    --tag "$EXECUTOR_IMAGE" \
    .

echo "✓ Executor image built: $EXECUTOR_IMAGE"

# Build warmer image
echo ""
echo "Building warmer image..."
docker build \
    --platform="$PLATFORM" \
    --build-arg KANIKO_VERSION="$KANIKO_VERSION" \
    --target kaniko-warmer \
    --tag "$WARMER_IMAGE" \
    .

echo "✓ Warmer image built: $WARMER_IMAGE"

# Push images if requested
if [ "$PUSH" = "true" ]; then
    echo ""
    echo "Pushing images..."
    docker push "$EXECUTOR_IMAGE"
    echo "✓ Pushed: $EXECUTOR_IMAGE"
    
    docker push "$WARMER_IMAGE"
    echo "✓ Pushed: $WARMER_IMAGE"
fi

echo ""
echo "========================================="
echo "Build complete!"
echo "========================================="
echo "Executor: $EXECUTOR_IMAGE"
echo "Warmer:   $WARMER_IMAGE"
