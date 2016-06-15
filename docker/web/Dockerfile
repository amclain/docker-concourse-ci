FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# Install system packages.
RUN apt-get -qq update && \
    apt-get -y install wget ssh

# Download concourse binary.
RUN wget https://github.com/concourse/concourse/releases/download/v1.2.0/concourse_linux_amd64
RUN chmod a+x concourse_linux_amd64

ADD bootstrap.sh ./bootstrap.sh
RUN chmod a+x ./bootstrap.sh

EXPOSE 8080 2222
VOLUME /var/concourse/keys

ENV USER myuser
ENV PASSWORD mypass
ENV EXTERNAL_URL http://localhost:8080
ENV POSTGRES_DATA_SOURCE postgres://postgres@db/postgres?sslmode=disable

ENTRYPOINT ["./bootstrap.sh"]
