#!/usr/bin/env bash
# Build the CV image and push it to GitHub Container Registry.
#
# The build-image workflow (.github/workflows/build-image.yaml) does this
# automatically whenever the Dockerfile, renv.lock or the CV template change.
# Use this script to bootstrap the image the first time (so the targets workflow
# has something to pull) or to rebuild and push manually.
#
# Requires $GITHUB_PAT to be a token with the write:packages scope.
IMAGE="ghcr.io/tarensanders/cv:latest"

echo "$GITHUB_PAT" | docker login ghcr.io -u tarensanders --password-stdin
# Pass the PAT as a BuildKit secret (never stored in the image/history/cache).
DOCKER_BUILDKIT=1 docker build --secret id=github_pat,env=GITHUB_PAT -t "$IMAGE" .
docker push "$IMAGE"
