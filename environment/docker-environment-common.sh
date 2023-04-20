#! /bin/bash

# Controls to help generalize Docker commands.

# Usage information
function help() {
  local bold=$(tput bold)
  local normal=$(tput sgr0)
  echo -e "${bold}Usage:${normal} $0 {start|stop|build|up|down|logs|images|version|labels|tags}"
  echo
  echo -e "Manage interactions with Docker / Compose"
  echo -e "Some commands, like version and tags, will only work if the container is already running."
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
    docker compose -f environment/compose.yml logs -f
    ;;

  start)
    retrieve_tag
    docker compose -f environment/compose.yml start
    ;;
    
  stop)
    retrieve_tag
    docker compose -f environment/compose.yml stop
    ;;
  up)
    retrieve_tag
    docker compose -f environment/compose.yml up -d
    ;;

  down)
    retrieve_tag
    docker compose -f environment/compose.yml down
    ;;

  images|version)
    retrieve_tag
    docker compose -f environment/compose.yml images
    ;;

  labels|tags)
    retrieve_tag
    CONTAINER_ID=`docker compose -f environment/compose.yml ps -q`
    if [ -z "$CONTAINER_ID" ]; then
      echo -e "No running containers. Try \`$0 build\` and \`$0 up\`"
      exit 5
    fi
    docker inspect --format='{{ range $k,$v:=.Config.Labels }}{{ if eq (printf "%.24s" $k) "org.opencontainers.image" }}{{ $k }}: {{ $v }}{{ printf "\n" }}{{end}}{{end}}' $CONTAINER_ID
    ;;

    
  build)
    REPOSITORY_URL="https://github.com/mtholyoke/docker-data-science-environment" ## NOTE: Update this.
    REVISION=$(git log --pretty=format:'%as_%h' -n 1)
    LATEST_GIT_TAG="$(git describe --abbrev=0 --tags)"
    BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
    # PROGRESS="--progress=plain" # Print debug information during Docker build phase
    NO_CACHE="--no-cache=true"

    # Configure image tag information from the Git commit hash, used in compose.yml and in docker-environment-common.sh
    export TAG=$REVISION_$LATEST_GIT_TAG
    echo $TAG > environment/image-tags

    # Build image
    docker compose -f environment/compose.yml build $NO_CACHE --build-arg BUILD_DATE=$BUILD_DATE --build-arg REVISION=$REVISION --build-arg REPOSITORY_URL=$REPOSITORY_URL --build-arg LATEST_GIT_TAG=$LATEST_GIT_TAG $PROGRESS datascience-notebook
    ;;
    
  *)
    echo -e "Invalid argument: $1"
    help
    exit 2
esac
