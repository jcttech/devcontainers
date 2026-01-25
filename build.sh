#!/bin/bash
set -e

REGISTRY="${REGISTRY:-ghcr.io}"
NAMESPACE="${NAMESPACE:-jcttech}"
VERSION="${VERSION:-latest}"

cd "$(dirname "$0")"

echo "=========================================="
echo "Building devcontainer images"
echo "Registry: ${REGISTRY}"
echo "Namespace: ${NAMESPACE}"
echo "Version: ${VERSION}"
echo "=========================================="

echo ""
echo "Building base image..."
docker build \
    --build-arg TZ="${TZ:-UTC}" \
    --build-arg CLAUDE_CODE_VERSION="${CLAUDE_CODE_VERSION:-latest}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-base:${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-base:latest" \
    ./base

echo ""
echo "Building python image..."
docker build \
    --build-arg REGISTRY="${REGISTRY}" \
    --build-arg NAMESPACE="${NAMESPACE}" \
    --build-arg BASE_VERSION="${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-python:${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-python:latest" \
    ./python

echo ""
echo "Building rust image..."
docker build \
    --build-arg REGISTRY="${REGISTRY}" \
    --build-arg NAMESPACE="${NAMESPACE}" \
    --build-arg BASE_VERSION="${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-rust:${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-rust:latest" \
    ./rust

echo ""
echo "Building python-rust image..."
docker build \
    --build-arg REGISTRY="${REGISTRY}" \
    --build-arg NAMESPACE="${NAMESPACE}" \
    --build-arg BASE_VERSION="${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-python-rust:${VERSION}" \
    -t "${REGISTRY}/${NAMESPACE}/devcontainer-python-rust:latest" \
    ./python-rust

echo ""
echo "=========================================="
echo "Build complete!"
echo "=========================================="
echo ""
echo "Images built:"
echo "  - ${REGISTRY}/${NAMESPACE}/devcontainer-base:${VERSION}"
echo "  - ${REGISTRY}/${NAMESPACE}/devcontainer-python:${VERSION}"
echo "  - ${REGISTRY}/${NAMESPACE}/devcontainer-rust:${VERSION}"
echo "  - ${REGISTRY}/${NAMESPACE}/devcontainer-python-rust:${VERSION}"
echo ""
echo "To push all:"
echo "  docker push ${REGISTRY}/${NAMESPACE}/devcontainer-base --all-tags"
echo "  docker push ${REGISTRY}/${NAMESPACE}/devcontainer-python --all-tags"
echo "  docker push ${REGISTRY}/${NAMESPACE}/devcontainer-rust --all-tags"
echo "  docker push ${REGISTRY}/${NAMESPACE}/devcontainer-python-rust --all-tags"
