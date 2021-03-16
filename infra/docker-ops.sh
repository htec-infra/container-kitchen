#!/bin/bash

IMAGE_NAME=${1}

# shellcheck disable=SC2210
IMAGE_VERSION=$(cat ./"${IMAGE_NAME}"/VERSION 2>/dev/null || echo "${2}")

LOCAL_IMAGE="local/${IMAGE_NAME}:${IMAGE_VERSION}"

# We want to push same images on multiple docker registries
DOCKER_REPOS=("htec" "public.ecr.aws/htec")

build() {
  docker build -t "${LOCAL_IMAGE}" --build-arg "VERSION=${IMAGE_VERSION}" "../apps/${IMAGE_NAME}/"
}

push() {
  if [ "${LOCAL_TEST}" == "true" ]; then
      return
  fi
  for REPO in "${DOCKER_REPOS[@]}"; do
    NEW_IMAGE="$REPO/${IMAGE_NAME}:${IMAGE_VERSION}"
    docker tag "local/${IMAGE_NAME}:${IMAGE_VERSION}" "${NEW_IMAGE}"
    docker push "${NEW_IMAGE}"

    # Remove tag after push
    docker rmi "${NEW_IMAGE}"
  done
}

cleanup() {
  if [ "${LOCAL_TEST}" == "true" ]; then
      echo "Skipping cleanup"
  else
      docker rmi "${LOCAL_IMAGE}"
  fi;

}

build && push  && cleanup

