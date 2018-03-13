#!/bin/bash

##############
## Settings ##
##############
SWARM_STACK_NAME="solideo-www-spring-swarm"
COMPOSE_SERVICE_NAME="spring"

#https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"







###########
## Build ##
###########

start_time=`date +%s`

# just make sure (if clean would fail)
echo "Deleting old distributions"
rm -f "$DIR/build/distributions/solideo-www-spring-boot.tar"

echo ""
echo "====BUILD===="
"$DIR/build.sh"
echo "============="
echo ""



######################
## Build evaluation ##
######################

function assure_swarm_mode() {
    if docker node ls > /dev/null 2>&1; then
        echo "Node already in swarm mode"
    else
        echo "Entering swarm mode..."
        docker swarm init
    fi
}

function is_already_deployed_to_stack() {
    is_already_deployed_to_stack_result="false"
    for x in `docker stack ls`; do
        if [[ $x = *"$SWARM_STACK_NAME"* ]]; then
            is_already_deployed_to_stack_result="true"
        fi
    done
}

if [ -e "$DIR/build/distributions/solideo-www-spring-boot.tar" ]
then
    echo "Build SUCCESS"
    assure_swarm_mode;
    is_already_deployed_to_stack;

    if [ "$is_already_deployed_to_stack_result" == "true" ]; then
        docker service update "${SWARM_STACK_NAME}_${COMPOSE_SERVICE_NAME}" --force --quiet
    else
        docker stack deploy -c docker-compose.yml $SWARM_STACK_NAME
    fi
else
    echo "Build FAILURE"
fi



end_time=`date +%s`
ellapsed_time=$((end_time-start_time))

echo "deploy=${ellapsed_time}s"
echo ""