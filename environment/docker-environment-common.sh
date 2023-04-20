#! /bin/bash

# Controls to help generalize Docker commands.

# Usage information
function help() {
  local bold=$(tput bold)
  local normal=$(tput sgr0)
  echo -e "${bold}Usage:${normal} $0 {start|stop|build|up|down|logs}"
  echo
  echo -e "Manage interactions with Docker / Compose"
}

# Retrieve the appropriate image/container tag and generate the `docker compose` command.
function retrieve_tag() {
  TAG_FILE="environment/image-tags"
  if [ ! -f "$TAG_FILE" ]; then
    echo "The tagfile $TAG_FILE does not exist, make sure to build the image!"
    exit 3
  fi
  TAG=$(head -n1 $TAG_FILE)

  if [ -z "${TAG}" ]; then
    echo "The tag in $TAG_FILE is empty, make sure to build the image!"
    exit 4
  fi
  export TAG
}


# Make sure Docker is running
if ! docker info > /dev/null 2>&1; then
  echo "This script uses Docker, and it isn't running - please start Docker and try again!"
  exit 1
fi

# Detect what action to take. Everything is handled pretty identically, aside from `build`.
case "$1" in
  logs)
    retrieve_tag
    CMD="docker compose -f environment/compose.yml logs -f"
    ;;

  start)
    retrieve_tag
    CMD="docker compose -f environment/compose.yml start"
    ;;
    
  stop)
    retrieve_tag
    CMD="docker compose -f environment/compose.yml stop"
    ;;
  up)
    retrieve_tag
    CMD="docker compose -f environment/compose.yml up -d"
    ;;

  down)
    retrieve_tag
    CMD="docker compose -f environment/compose.yml down"
    ;;
    
  build)
    # Configure the image label information
    ## Look at with
    ### `docker image ls` to find the image
    ###     – given `image: datascience-notebook:$TAG` in compose.yml, the image name is `datascience-notebook`
    ### `docker inspect datascience-notebook:2023-04-18  | grep "org.label-schema"` to inspect the image
    ###     - use the image name and the tag from `docker image ls`
    ### You can also cross-reference the "IMAGE ID" from `docker image ls` with the "IMAGE" from `docker container ls`

    VCS_COMMIT_HASH=$(git log --pretty=format:'%h' -n 1)
    NO_CACHE="--no-cache=true"
    BUILD_DATE="--build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
    VCS_REF="--build-arg VCS_REF=$VCS_COMMIT_HASH"
    # PROGRESS="--progress=plain"

    # Configure image tag information from the Git commit hash, used in compose.yml and in docker-environment-common.sh
    export TAG=$VCS_COMMIT_HASH
    echo $TAG > environment/image-tags

    # Build image
    CMD="docker compose -f environment/compose.yml build $NO_CACHE $BUILD_DATE $VCS_REF $PROGRESS datascience-notebook"
    ;;
    
  *)
    echo -e "Invalid argument: $1"
    help
    exit 2
esac

# Do the thing
echo $CMD
$CMD
