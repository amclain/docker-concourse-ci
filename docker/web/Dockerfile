FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# Install system packages.
RUN apt-get -qq update && \
    apt-get -y install wget ssh

# Download concourse binary.
RUN wget https://github.com/concourse/concourse/releases/download/v1.2.0/concourse_linux_amd64
RUN chmod a+x concourse_linux_amd64

# Generate keys.
RUN ssh-keygen -t rsa -b 4096 -f host_key -N ''
RUN ssh-keygen -t rsa -b 4096 -f worker_key -N ''
RUN ssh-keygen -t rsa -b 4096 -f session_signing_key -N ''

RUN cp worker_key.pub authorized_worker_keys

CMD ./concourse_linux_amd64 web \
  --basic-auth-username myuser \
  --basic-auth-password mypass \
  --session-signing-key session_signing_key \
  --tsa-host-key host_key \
  --tsa-authorized-keys authorized_worker_keys \
  --external-url http://172.17.0.1 \
  --postgres-data-source postgres://postgres@db/postgres?sslmode=disable
