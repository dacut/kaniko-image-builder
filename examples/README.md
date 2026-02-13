# Example: Building a simple Docker image with Kaniko

This example shows how to use the Kaniko executor to build a simple Docker image.

## Prerequisites

- Docker or Podman installed
- Access to one of the Kaniko executor images from this repository

## Files

- `Dockerfile.example` - A simple example Dockerfile to build
- `build.sh` - Script to build the image using Kaniko

## Usage

### Using Docker

```bash
# Build the example using Kaniko executor from GitHub Container Registry
docker run -v $(pwd):/workspace \
  ghcr.io/dacut/kaniko-executor:latest \
  --dockerfile=/workspace/Dockerfile.example \
  --context=/workspace \
  --destination=my-example-image:latest \
  --no-push
```

### Using Kubernetes

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: kaniko-build
spec:
  containers:
  - name: kaniko
    image: ghcr.io/dacut/kaniko-executor:latest
    args:
    - "--dockerfile=/workspace/Dockerfile.example"
    - "--context=/workspace"
    - "--destination=my-registry/my-image:latest"
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker/
    - name: workspace
      mountPath: /workspace
  volumes:
  - name: docker-config
    secret:
      secretName: docker-config
  - name: workspace
    persistentVolumeClaim:
      claimName: workspace-pvc
  restartPolicy: Never
```

## Notes

- Use `--no-push` flag to build locally without pushing to a registry
- Use `--cache=true` and `--cache-repo=<repo>` to enable caching
- Mount Docker credentials to `/kaniko/.docker/config.json` for authenticated pushes
