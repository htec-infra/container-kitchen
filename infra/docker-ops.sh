#!/bin/bash

# Input vars
REPOSITORY_NAME=${1}
FLAVOR_NAME=${2} # optional

# Static vars
DOCKER_REPOS=("public.ecr.aws/htec")
BASE_DIR="$PWD/apps"
FULL_PATH=$BASE_DIR/$REPOSITORY_NAME/$FLAVOR_NAME
SUBDIRS=$(find ${FULL_PATH} -maxdepth 1 -type d | wc -l)
IMAGE_VERSION=$(cat "${FULL_PATH}"/VERSION 2>/dev/null || echo "${3}")


# Main function is responsible for checking if manadatory variable is provided
# If provided then loop through the docker repos and build an image for every repo
main(){
  if [ -z "$REPOSITORY_NAME" ] ; then
      echo -e "     
      #####################################\n
      Mandatory argument is not provided\n
      #####################################
      "
    else
      for REPO in "${DOCKER_REPOS[@]}"; do
        build_and_push
      done
  fi
}

# TO-DO
# Improve logic of the function build_and_push
# This functions is responsible for formating the given input and calling appropriate functions with the formated input.
build_and_push() {
    if [[ "${SUBDIRS}" -eq 1 ]]
    then
      for FOLDER in $(ls -d ${FULL_PATH}); do
        IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}
        build_image $IMAGE_NAME $FOLDER $DRY_RUN
        push_image $IMAGE_NAME $DRY_RUN
        remove_image $IMAGE_NAME $DRY_RUN
      done
    else
      for FOLDER in $(ls -d ${FULL_PATH}/*/); do
        if [ -f "${FOLDER}/Dockerfile" ]; then
          IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}-$(basename "$FOLDER/")
          build_image $IMAGE_NAME $FOLDER $DRY_RUN
          push_image $IMAGE_NAME $DRY_RUN
          remove_image $IMAGE_NAME $DRY_RUN
        else
          FOLDER=$(ls -d ${FULL_PATH})
          IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}
          build_image $IMAGE_NAME $FOLDER $DRY_RUN
          push_image $IMAGE_NAME $DRY_RUN
          remove_image $IMAGE_NAME $DRY_RUN
        fi
      done
    fi
}

build_image(){
  local IMAGE_NAME="$1"
  local FOLDER="$2"
  local DRY_RUN="$3"

  if [ "$DRY_RUN" = "true" ] ; then
    docker build -t local/$IMAGE_NAME "$FOLDER/"
  else
    docker build -t $IMAGE_NAME "$FOLDER/"
  fi
}

push_image(){
  local IMAGE_NAME="$1"
  local DRY_RUN="$2"

  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
    #####################################\n
    DRY_RUN is enabled, push is skipped\n
    #####################################
    "
  else
    echo docker push -t $IMAGE_NAME
  fi
}

remove_image(){
  local IMAGE_NAME="$1"
  local DRY_RUN="$2"

  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
    #####################################\n
    DRY_RUN is enabled, cleanup is skipped\n
    #####################################
    "
  else
    docker rmi $IMAGE_NAME
  fi
}

main