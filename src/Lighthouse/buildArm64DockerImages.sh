#!/usr/bin/env bash
##########################################################################
# Build local Alpine Linux Docker images using the current project.
# Script is designed to be run inside the root directory of the Akka.Bootstrap.Docker.Sample project.
##########################################################################
# https://hub.docker.com/_/microsoft-dotnet-runtime
# https://github.com/dotnet/dotnet-docker/tree/main/samples

IMAGE_VERSION=$1
IMAGE_NAME=$2
USER_NAME=$3

if [ -z $IMAGE_VERSION ]; then
	echo `date`" - Missing mandatory argument: Docker image version."
	echo `date`" - Usage: ./buildDockerImagesLinux.sh [imageVersion] [imageName]"
	exit 1
fi

if [ -z $IMAGE_NAME ]; then
	IMAGE_NAME="akka.docker.boostrap"
	echo `date`" - Using default Docker image name [$IMAGE_NAME]"
fi

if [ -z $USER_NAME ]; then
	USER_NAME="petabridge"
	echo `date`" - Using default Docker user name [$USER_NAME]"
fi


echo "Building project..."
dotnet publish -c Release
dotnet build-server shutdown

ARM_IMAGE="$USER_NAME/$IMAGE_NAME:$IMAGE_VERSION-arm"
ARM_IMAGE_LATEST="$USER_NAME/$IMAGE_NAME:latest-arm"

echo "Creating Docker (Linux) image [$ARM_IMAGE]..."
docker buildx build --push --platform linux/arm64 -f Dockerfile-arm64  -t $ARM_IMAGE  -t $ARM_IMAGE_LATEST .