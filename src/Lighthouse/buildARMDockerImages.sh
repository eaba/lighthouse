#!/usr/bin/env bash
##########################################################################
# Build local Alpine Linux Docker images using the current project.
# Script is designed to be run inside the root directory of the Akka.Bootstrap.Docker.Sample project.
##########################################################################

IMAGE_VERSION=$1
IMAGE_NAME=$2

if [ -z $IMAGE_VERSION ]; then
	echo `date`" - Missing mandatory argument: Docker image version."
	echo `date`" - Usage: ./buildDockerImagesLinux.sh [imageVersion] [imageName]"
	exit 1
fi

if [ -z $IMAGE_NAME ]; then
	IMAGE_NAME="akka.docker.boostrap"
	echo `date`" - Using default Docker image name [$IMAGE_NAME]"
fi


echo "Building project..."
dotnet publish -c Release
dotnet build-server shutdown

ARM_IMAGE="$IMAGE_NAME:$IMAGE_VERSION-arm64"
ARM_IMAGE_LATEST="$IMAGE_NAME:latest-arm64"

echo "Creating Docker (Linux) image [$ARM_IMAGE]..."
# your_docker_username/multi_arch_sample:buildx-latest
docker buildx build --push --platform linux/amd64,linux/arm64 -f Dockerfile-arm64 --tag $ARM_IMAGE/$ARM_IMAGE_LATEST  .