#!/bin/bash

# Input vars
REPOSITORY_NAME=${1}
FLAVOR_NAME=${2} # optional

# Static vars
DOCKER_REPOS=("public.ecr.aws/htec")
DIR="apps/${REPOSITORY_NAME}/${FLAVOR_NAME}"
IMAGE_VERSION=$(cat "${DIR}"/VERSION 2>/dev/null || echo "${3}")
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
        build_image $REPO $DIR
      done
  fi
  # Wait for prepared data from previous function and proceed with the push and cleanup process.
  push_image "$DRY_RUN"
  remove_image "$DRY_RUN"
}

build_image (){
    # Arguments
    local REPO=$1
    local DIR=$2

    # Variables
    DOCKERFILES=$(cd "$DIR"; find * -name '*Dockerfile')

    for FILE in ${DOCKERFILES[@]} ; do
        # Take a directory where dockerfile is and take the basedir as path where the image will be built
        CONTEXT="$(dirname "${FILE}")"
        # Take a directory where dockerfile is and take the basedir, replace "//" with "-"
        TAG=$(dirname "${FILE}" | tr "//" "-")
        # Docker image name is assembled from input parameters, "${TAG#.}" and "sed -e 's|-$||g'" remove the dot(.) and hyphen(-) if the docker file is located in the root direcotry
        IMAGE_NAME=$(echo "$DOCKER_REPOS/$REPOSITORY_NAME:""$IMAGE_VERSION-""${TAG#.}" | sed -e 's|-$||g')

        if [ "$DRY_RUN" = "true" ] ; then
          echo docker build -t "$IMAGE_NAME" -f "$DIR/$FILE" "$DIR/$CONTEXT"
          # Append array to variable with \n in order to escape for loop in push_image and remove_image
          IMAGES+=("$IMAGE_NAME\n")
        else
          # Start the build process
          docker build -t "$IMAGE_NAME" -f "$DIR/$FILE" "$DIR/$CONTEXT"
          # Append array to variable
          IMAGES+=("$IMAGE_NAME")
        fi
    done

}

push_image(){
  # Argument
  local DRY_RUN="$1"

  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
#####################################\n
DRY_RUN is enabled, push is skipped for image/s:
"${IMAGES[@]}"\n
#####################################
    "
  else
    for IMAGE in ${IMAGES[@]} ; do
      docker push $IMAGE
    done
  fi
}

remove_image(){
  # Argument
  local DRY_RUN="$1"

  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
#####################################\n
DRY_RUN is enabled, remove is skipped for image/s:
"${IMAGES[@]}"\n
#####################################
    "
  else
    for IMAGE in "${IMAGES[@]}" ; do
      docker rmi "$IMAGE"
    done
  fi
}

main