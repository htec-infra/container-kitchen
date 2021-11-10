#!/bin/bash

# Input vars
REPOSITORY_NAME=${1}
FLAVOR_NAME=${2} # optional

# Static vars
DOCKER_REPOS=("public.ecr.aws/htec" "docker.hub/htec" "eu.gcr.io/htec")
BASE_DIR="$PWD/apps"
FULL_PATH=$BASE_DIR/$REPOSITORY_NAME/$FLAVOR_NAME
SUBDIRS=$(find ${FULL_PATH} -maxdepth 1 -type d | wc -l)
IMAGE_VERSION=$(cat "${FULL_PATH}"/VERSION 2>/dev/null || echo "${3}")



main(){
  if [ -z "$REPOSITORY_NAME" ] ; then
      echo "No mandatory argument supplied"
    else
      for REPO in "${DOCKER_REPOS[@]}"; do
        build_and_push
      done
  fi
}


# Functions
build_and_push() {
    if [[ "${SUBDIRS}" -eq 1 ]]
    then
      for FOLDER in $(ls -d ${FULL_PATH}); do
        IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}
        build_image $DRY_RUN $IMAGE_NAME $FOLDER
        push_image $DRY_RUN $IMAGE_NAME
        remove_image $DRY_RUN $IMAGE_NAME
      done
    else
      for FOLDER in $(ls -d ${FULL_PATH}/*/); do
        if [ -f "Dockerfile" ]; then
          IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}-$(basename "$FOLDER/")
          build_image $DRY_RUN $IMAGE_NAME $FOLDER
          push_image $DRY_RUN $IMAGE_NAME
          remove_image $DRY_RUN $IMAGE_NAME
        else
          FOLDER=$(ls -d ${FULL_PATH})
          IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}
          build_image $DRY_RUN $IMAGE_NAME $FOLDER
          push_image $DRY_RUN $IMAGE_NAME
          remove_image $DRY_RUN $IMAGE_NAME
        fi
      done
    fi
}

build_image(){
  local DRY_RUN="$1"
  local IMAGE_NAME="$2"
  local FOLDER="$3"

  if [ "$DRY_RUN" = "true" ] ; then
    docker build -t local/$IMAGE_NAME "$FOLDER/"
  else
    docker build -t $IMAGE_NAME "$FOLDER/"
  fi
}

push_image(){
  local DRY_RUN="$1"
  local IMAGE_NAME="$2"

  if [ "$DRY_RUN" = "true" ] ; then
    echo "Push disabled"
  else
    echo docker push -t $IMAGE_NAME
  fi
}

remove_image(){

  local DRY_RUN="$1"
  local IMAGE_NAME="$2"

  if [ "$DRY_RUN" = "true" ] ; then
    echo "Cleanup skipped"
  else
    docker rmi $IMAGE_NAME
  fi

}

main