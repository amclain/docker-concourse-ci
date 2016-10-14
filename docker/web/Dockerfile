FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# ------------------------------------------------------------------------------
# Keep this part of the file synced with the worker Dockerfile so the images
# share the same base for the large binary without the need for creating an
# explicit base image with another Dockerfile.

# Install system packages.
RUN apt-get -qq update && \
    apt-get -y install wget ssh

# Download concourse binary.
RUN wget https://github.com/concourse/concourse/releases/download/v2.3.1/concourse_linux_amd64
RUN chmod a+x concourse_linux_amd64
# ------------------------------------------------------------------------------

ADD bootstrap.sh ./bootstrap.sh
RUN chmod a+x ./bootstrap.sh

EXPOSE 8080 2222
VOLUME /var/concourse/keys

ENV USER myuser
ENV PASSWORD mypass
ENV EXTERNAL_URL http://localhost:8080
ENV POSTGRES_DATA_SOURCE postgres://postgres@db/postgres?sslmode=disable

ENTRYPOINT ["./bootstrap.sh"]
