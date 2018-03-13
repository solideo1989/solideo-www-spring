#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within

##
# This script needs configuration file named build-deploy-notify.cfg
# Example:
#
# pushover_apptoken=
# pushover_usertoken=
# instance_name=
# 
##

if ! [ -e "$DIR/build-deploy-notify.cfg" ]
then
    echo "This script needs configuration file named build-deploy-notify.cfg"
    echo ""
    echo "Running without notify"

    "$DIR/swarm-deploy.sh" 2>&1 | tee deployment.log

else

    source "$DIR/build-deploy-notify.cfg"

    "$DIR/swarm-deploy.sh" 2>&1 | tee deployment.tmp.log

    message=$( tail -c 960 deployment.tmp.log )
    message=$message$'\n\n[ '$( date )$' ]'

    echo "Build completed, uploading a gist..."

    gist_url=$( echo $message | nc termbin.com 9999 )

    message=$message$'\n\n'$gist_url

    echo "Sending notification"

    curl -v \
      --form-string "token=$pushover_apptoken" \
      --form-string "user=$pushover_usertoken" \
      --form-string "title=Deploy finished on $instance_name" \
      --form-string "url=$gist_url" \
      --form-string "message=$message" \
      https://api.pushover.net/1/messages.json

    echo "Notification sent";

    rm deployment.tmp.log

    echo ""
    echo ""

fi