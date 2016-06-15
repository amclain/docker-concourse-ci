FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# Install system packages.
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb http://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
RUN apt-get -qq update && \
    apt-get -y install wget ssh git docker-engine

# Download concourse binary.
RUN wget https://github.com/concourse/concourse/releases/download/v1.2.0/concourse_linux_amd64
RUN chmod a+x concourse_linux_amd64
RUN mkdir -p /opt/concourse/worker

ADD bootstrap.sh ./bootstrap.sh
RUN chmod a+x ./bootstrap.sh

VOLUME /var/concourse/keys

ENV TSA_HOST web
ENV DNS_SERVER 8.8.8.8

ENTRYPOINT ["./bootstrap.sh"]
