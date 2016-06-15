FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# Install system packages.
RUN apt-get -qq update && \
    apt-get -y install wget ssh

# Download concourse binary.
RUN wget https://github.com/concourse/concourse/releases/download/v1.2.0/concourse_linux_amd64
RUN chmod a+x concourse_linux_amd64

EXPOSE 8080 2222
VOLUME /var/concourse/keys

CMD ./concourse_linux_amd64 web \
  --basic-auth-username myuser \
  --basic-auth-password mypass \
  --session-signing-key /var/concourse/keys/session_signing_key \
  --tsa-host-key /var/concourse/keys/host_key \
  --tsa-authorized-keys /var/concourse/keys/authorized_worker_keys \
  --external-url http://localhost:8080 \
  --postgres-data-source postgres://postgres@db/postgres?sslmode=disable
