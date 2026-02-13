#!/bin/bash
# Example script to build a Docker image using Kaniko

set -e

EXECUTOR_IMAGE="${EXECUTOR_IMAGE:-ghcr.io/dacut/kaniko-executor:latest}"
DESTINATION="${DESTINATION:-my-example-image:latest}"

echo "Building image using Kaniko..."
echo "Executor image: $EXECUTOR_IMAGE"
echo "Destination: $DESTINATION"

docker run --rm -v "$(pwd)":/workspace \
  "$EXECUTOR_IMAGE" \
  --dockerfile=/workspace/Dockerfile.example \
  --context=/workspace \
  --destination="$DESTINATION" \
  --no-push

echo "Build complete!"
echo "Image built: $DESTINATION"
