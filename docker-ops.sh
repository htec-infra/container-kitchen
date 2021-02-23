#!/bin/bash

IMAGE_NAME=${1}

IMAGE_VERSION=${2}

LOCAL_IMAGE="local/${IMAGE_NAME}:${IMAGE_VERSION}"

# We want to push same images on multiple docker registries
DOCKER_REPOS=("htec" "public.ecr.aws/htec")

build() {
  docker build -t "${LOCAL_IMAGE}" --build-arg "VERSION=${IMAGE_VERSION}" \
    -f "${IMAGE_NAME}/Dockerfile" .
}

push() {
  for REPO in "${DOCKER_REPOS[@]}"; do
    NEW_IMAGE="$REPO/${IMAGE_NAME}:${IMAGE_VERSION}"
    docker tag "local/${IMAGE_NAME}:${IMAGE_VERSION}" "${NEW_IMAGE}"
    docker push "${NEW_IMAGE}"

    # Remove tag after push
    docker rmi "${NEW_IMAGE}"
  done
}

cleanup() {
  docker rmi "${LOCAL_IMAGE}"
}

build && push && cleanup

