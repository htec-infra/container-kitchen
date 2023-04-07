#!/bin/bash

# Input vars
REPOSITORY_NAME=${1}
FLAVOR_NAME=${2} # optional

# Static vars
CONTAINER_REPOS=("public.ecr.aws/htec")
DIR="apps/${REPOSITORY_NAME}/${FLAVOR_NAME}"
IMAGE_VERSION=$(cat "${DIR}"/VERSION 2>/dev/null || echo "${3}")
IMAGES=()

# Main function is responsible for checking if manadatory variable is provided
# If provided then loop through the container repos and build an image for every repo
main(){
  if [ -z "${REPOSITORY_NAME}" ] ; then
      echo -e "     
      #####################################\n
      Mandatory argument is not provided\n
      #####################################
      "
    else
      for REPO in "${CONTAINER_REPOS[@]}"; do
        build_image "${REPO}" "${DIR}"
      done
  fi
  # Wait for prepared data from previous function and proceed with the push and cleanup process.
  push_image "${IMAGES[*]}"
  remove_image "${IMAGES[*]}"
}

build_image (){
    # Parameters
    local REPO="$1"
    local DIR="$2"

    # Variables
    DOCKERFILES=$(cd "${DIR}" || exit ; find * -name '*Dockerfile')

    for FILE in ${DOCKERFILES[@]} ; do
        # Take a directory where dockerfile is and take the basedir as path where the image will be built
        CONTEXT="$(dirname "${FILE}")"
        # Take a directory where dockerfile is and take the basedir, replace "//" with "-"
        TAG=$(dirname "${FILE}" | tr "//" "-")
        # Container image name is assembled from input parameters, "${TAG#.}" and "sed -e 's|-$||g'" remove the dot(.) and hyphen(-) if the dockerfile is located in the root direcotry
        IMAGE_NAME=$(echo "${REPO}/${REPOSITORY_NAME}:${IMAGE_VERSION}-${TAG#.}" | sed -e 's|-$||g')
        # Build command
        BUILD=("docker" "build" "-t" "${IMAGE_NAME}" "-f" "${DIR}/${FILE}" "${DIR}/${CONTEXT}")
        if [ "${DRY_RUN}" = "true" ] ; then
          echo "${BUILD[@]}"
        else
          # Start the build process
          "${BUILD[@]}"
        fi
        # Append array to variable
        IMAGES+=("${IMAGE_NAME}")
    done
}


push_image(){
  # Parameters
  local IMAGES="$1"

  if [ "${DRY_RUN}" = "true" ] ; then
    echo -e "
#####################################\n
DRY_RUN is enabled, push is skipped for image/s:\n"
    format_image_names "${IMAGES[@]}"

  else
    for IMAGE in ${IMAGES[@]} ; do
      docker push "${IMAGE}"
    done
  fi
}

remove_image(){
  # Parameters
  local IMAGES="$1"

  if [ "${DRY_RUN}" = "true" ] ; then
    echo -e "     
#####################################\n
DRY_RUN is enabled, remove is skipped for image/s:\n"
    format_image_names "${IMAGES[@]}"

  else
    for IMAGE in ${IMAGES[@]} ; do
      docker rmi "${IMAGE}"
    done
  fi
}

format_image_names(){
  # Parameters
  local IMAGES="$1"

  echo "${IMAGES[@]}" | tr " " "\n"
}

main
