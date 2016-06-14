FROM ubuntu:trusty
MAINTAINER Alex McLain <alex@alexmclain.com>

# Install system packages.
RUN apt-get -qq update && \
    apt-get -y install wget ssh

# Download concourse binary.
RUN wget https://github.com/concourse/concourse/releases/download/v1.2.0/concourse_linux_amd64
RUN chmod a+x concourse_linux_amd64

# Generate keys.
RUN ssh-keygen -t rsa -b 4096 -f worker_key -N ''
RUN cp worker_key.pub authorized_worker_keys

RUN mkdir -p /opt/concourse/worker

CMD ./concourse_linux_amd64 worker \
  --work-dir /opt/concourse/worker \
  --tsa-host web \
  --tsa-public-key host_key.pub \
  --tsa-worker-private-key worker_key
