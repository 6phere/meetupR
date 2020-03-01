FROM jenkins/jenkins:lts
MAINTAINER Sixphere <codelovers@sixphere.com>

USER root

# Install docker dependencies
RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ | sh

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

# Expose docker socket
VOLUME /var/lib/docker
RUN echo "Socket" >> /var/run/docker.sock

# Grant permissions
RUN chown -R root:docker /var/lib/docker
RUN chown -R root:docker /var/run/docker.sock
RUN usermod -a -G staff,docker jenkins

EXPOSE 8080 50000

USER jenkins
