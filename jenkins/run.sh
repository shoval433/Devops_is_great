#!/bin/bash

# takes the group
Host_Docker=`getent group | grep docker | cut -d ":" -f3`
# Builds the Dockerfile with the group variable
docker build --build-arg Docker_group=${Host_Docker} -t jenkins-img .
# Run the server including a named volume for data persistence
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
--restart always -v jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock jenkins-img


