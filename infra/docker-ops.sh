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
    local REPO=$1
    local DIR=$2

    DOCKERFILES=$(cd "$DIR"; find * -name '*Dockerfile')

    if [ "$DRY_RUN" = "true" ] ; then
          echo -e "     
#####################################\n
DRY_RUN is enabled, docker build command is:
\n"
      for i in ${DOCKERFILES[@]} ; do
          # Take a directory where dockerfile is and take the basedir as path where the image will be built
          CONTEXT="$(dirname "${i}")"
          # Take a directory where dockerfile is and take the basedir, replace "//" with "-"
          TAG=$(dirname "${i}" | tr "//" "-")
          # Docker image name is assembled from input parameters, "${TAG#.}" and "sed -e 's|-$||g'" removed the dot(.) and - if the docker file is located in the root direcotry
          IMAGE_NAME=$(echo "$REPO/$REPOSITORY_NAME:""$IMAGE_VERSION-""${TAG#.}" | sed -e 's|-$||g')
          # Disable build procress
          echo docker build -t "$IMAGE_NAME" -f "$DIR/$i" "$DIR/$CONTEXT"
          # Append array to variable
          IMAGES+=("$IMAGE_NAME\n")
      done

# Zamneji DOCKER_REPOS sa REPO
    else

      for i in ${DOCKERFILES[@]} ; do
          # Take a directory where dockerfile is and take the basedir as path where the image will be built
          CONTEXT="$(dirname "${i}")"
          # Take a directory where dockerfile is and take the basedir, replace "//" with "-"
          TAG=$(dirname "${i}" | tr "//" "-")
          # Docker image name is assembled from input parameters, "${TAG#.}" and "sed -e 's|-$||g'" removed the dot(.) and - if the docker file is located in the root direcotry
          IMAGE_NAME=$(echo "$DOCKER_REPOS/$REPOSITORY_NAME:""$IMAGE_VERSION-""${TAG#.}" | sed -e 's|-$||g')
          # Start the build process
          docker build -t "$IMAGE_NAME" -f "$DIR/$i" "$DIR/$CONTEXT"
          # Append array to variable
          IMAGES+=("$IMAGE_NAME")
      done


    fi

}

push_image(){
  local DRY_RUN="$1"
  FORMAT=()
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
  local DRY_RUN="$1"
  FORMAT=()
  if [ "$DRY_RUN" = "true" ] ; then
    echo -e "     
#####################################\n
DRY_RUN is enabled, remove is skipped for image/s:
"${IMAGES[@]}"\n
#####################################
    "
  else
    for IMAGE in "${IMAGES[@]}" ; do
      echo docker rmi "$IMAGE"
    done
  fi
}

main