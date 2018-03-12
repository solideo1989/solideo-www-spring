#!/bin/bash

#https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOCKER_IMAGE="gradle:jdk8"
GRADLE_HOME_VOLUME="gradlehome"
GRADLE_CMD="clean build"

docker run -t --rm --name solideo-www-spring-builder \
 -v "$GRADLE_HOME_VOLUME":/home/gradle/.gradle -v "$DIR":/home/gradle/project \
 -w /home/gradle/project $DOCKER_IMAGE gradle $GRADLE_CMD