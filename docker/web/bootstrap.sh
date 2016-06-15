#! /bin/bash
exec ./concourse_linux_amd64 web \
  --basic-auth-username $USER \
  --basic-auth-password $PASSWORD \
  --session-signing-key /var/concourse/keys/session_signing_key \
  --tsa-host-key /var/concourse/keys/host_key \
  --tsa-authorized-keys /var/concourse/keys/authorized_worker_keys \
  --external-url $EXTERNAL_URL \
  --postgres-data-source $POSTGRES_DATA_SOURCE
