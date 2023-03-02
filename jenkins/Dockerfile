FROM jenkins/jenkins:lts-jdk11
ARG  Docker_group
# Move to Root
USER root
# Adds the Docker's group just like in HOST
RUN groupadd -g ${Docker_group} docker
# Docker installer
RUN apt-get update -y && \
apt install docker.io -y && \
apt install docker-compose -y && \
usermod -aG docker jenkins
# Back to jenkins user (Only root can perform actions and user jenkins is limited)
USER jenkins