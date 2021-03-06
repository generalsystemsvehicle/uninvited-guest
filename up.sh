#!/usr/bin/env bash

clear

rm -fr ./docker-environment/GUACAMOLE_HOME/extensions/uninvited_guest-guacamole-auth-hmac-1.0.1.jar
cd extension
if ! mvn package ; then
    cd ..
    exit;
fi
cd ..
cp ./extension/target/uninvited_guest-guacamole-auth-hmac-1.0.1.jar ./docker-environment/GUACAMOLE_HOME/extensions/

clear

docker-compose -f ./docker-environment/docker-compose.yml up