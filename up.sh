#!/usr/bin/env bash

clear

rm -fr ./docker-environment/GUACAMOLE_HOME/extensions/guacamole-auth-hmac-1.0.0.jar
cd extension
if ! mvn package ; then
    cd ..
    exit;
fi
cd ..
cp ./extension/target/guacamole-auth-hmac-1.0.0.jar ./docker-environment/GUACAMOLE_HOME/extensions/

clear

docker-compose -f ./docker-environment/docker-compose.yml up