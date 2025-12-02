#!/bin/bash
# Script to build and push Docker image to GitHub Container Registry (ghcr.io)

set -e

# Configuration
GITHUB_USERNAME="The-Mj-01"
GITHUB_USERNAME_LOWER="the-mj-01"  # ghcr.io requires lowercase
REPO_NAME="az-iranian-bank-gateways"
IMAGE_NAME="test-project-web"
VERSION="${1:-latest}"  # Use first argument as version, default to 'latest'

# Full image name for ghcr.io (must be lowercase)
FULL_IMAGE_NAME="ghcr.io/${GITHUB_USERNAME_LOWER}/${IMAGE_NAME}:${VERSION}"

echo "=========================================="
echo "Building Docker image..."
echo "=========================================="

# Build the image from the root directory (one level up from test_project)
cd "$(dirname "$0")/.."
docker build -f test_project/Dockerfile -t ${IMAGE_NAME}:${VERSION} .

echo ""
echo "=========================================="
echo "Tagging image for ghcr.io..."
echo "=========================================="

# Tag the image for ghcr.io
docker tag ${IMAGE_NAME}:${VERSION} ${FULL_IMAGE_NAME}

echo "Image tagged as: ${FULL_IMAGE_NAME}"
echo ""
echo "=========================================="
echo "Login to GitHub Container Registry..."
echo "=========================================="
echo "Please enter your GitHub Personal Access Token (PAT) when prompted."
echo "You can create a PAT at: https://github.com/settings/tokens"
echo "Required scopes: write:packages, read:packages"
echo ""

# Login to ghcr.io
if [ -n "${GITHUB_TOKEN}" ]; then
    echo "${GITHUB_TOKEN}" | docker login ghcr.io -u ${GITHUB_USERNAME} --password-stdin
else
    echo "Please enter your GitHub Personal Access Token:"
    docker login ghcr.io -u ${GITHUB_USERNAME}
fi

echo ""
echo "=========================================="
echo "Pushing image to ghcr.io..."
echo "=========================================="

# Push the image
docker push ${FULL_IMAGE_NAME}

echo ""
echo "=========================================="
echo "Success! Image pushed to:"
echo "${FULL_IMAGE_NAME}"
echo "=========================================="
echo ""
echo "You can view your package at:"
echo "https://github.com/${GITHUB_USERNAME}?tab=packages"
echo ""

