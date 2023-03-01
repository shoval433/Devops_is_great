FROM jenkins/jenkins:lts-jdk11
ARG  Docker_group
USER root
RUN groupadd -g ${Docker_group} docker
RUN apt-get update -y && \
apt install docker.io -y && \
apt install docker-compose -y && \
usermod -aG docker jenkins
USER jenkins