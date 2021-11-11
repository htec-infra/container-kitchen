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
IMAGES=()

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
        build_and_prepare_data
      done
  fi
  # Wait for prepared data from previous function and proceed with the push and cleanup process.
  push_image $IMAGES $DRY_RUN
  remove_image $IMAGES $DRY_RUN
}

# TO-DO
# Improve logic of the function build_and_prepare_data
# This functions is responsible for formating the given input and bulding the docker images.
build_and_prepare_data() {
    if [[ "${SUBDIRS}" -eq 1 ]]
    then
      for FOLDER in $(ls -d ${FULL_PATH}); do
        IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}
        build_image $IMAGE_NAME $FOLDER $DRY_RUN
        # Append value to a variable
        IMAGES+="${IMAGE_NAME};"
      done
    else
      for FOLDER in $(ls -d ${FULL_PATH}/*/); do
        if [ -f "${FOLDER}/Dockerfile" ]; then
          IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}-$(basename "$FOLDER/")
          build_image $IMAGE_NAME $FOLDER $DRY_RUN
          # Append value to a variable
          IMAGES+="${IMAGE_NAME};"
        else
          FOLDER=$(ls -d ${FULL_PATH})
          IMAGE_NAME=$REPO/${REPOSITORY_NAME}:${IMAGE_VERSION}
          build_image $IMAGE_NAME $FOLDER $DRY_RUN
          # Append value to a variable
          IMAGES+="${IMAGE_NAME};"
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
  local IMAGES="$(echo $1 | tr ";" "\n")"
  local DRY_RUN="$2"

  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
#####################################\n
DRY_RUN is enabled, push is skipped for image/s:
local/$IMAGES \n
#####################################
    "
  else
    for IMAGE in ${IMAGES[@]} ; do
      docker push $IMAGE
    done
  fi
}

remove_image(){
  local IMAGES="$(echo $1 | tr ";" "\n")"
  local DRY_RUN="$2"

  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
#####################################\n
DRY_RUN is enabled, push is skipped for image/s:
local/$IMAGES \n
#####################################
    "
  else
    for IMAGE in ${IMAGES[@]} ; do
      docker rmi $IMAGE
    done
  fi
}

main