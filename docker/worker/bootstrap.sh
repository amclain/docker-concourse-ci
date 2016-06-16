#! /bin/bash
exec ./concourse_linux_amd64 worker \
  --work-dir /opt/concourse/worker \
  --tsa-host $TSA_HOST \
  --tsa-public-key /var/concourse/keys/host_key.pub \
  --tsa-worker-private-key /var/concourse/keys/worker_key\
  -- -dnsServer $DNS_SERVER
