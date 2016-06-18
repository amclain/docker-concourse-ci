# docker-concourse-ci

A set of [Docker](https://www.docker.com/) containers that run [Concourse CI](https://concourse.ci/).

## Issues, Bugs, Feature Requests

Any bugs and feature requests should be reported on the GitHub issue tracker:

https://github.com/amclain/docker-concourse-ci/issues


**Pull requests are preferred via GitHub.**

Mercurial users can use [Hg-Git](http://hg-git.github.io/) to interact with
GitHub repositories.

## Installation

Prerequisites:
* Linux kernel 3.19 or greater (the worker can't run without this)
* [docker](https://docs.docker.com/engine/installation/)
* [docker-compose](https://docs.docker.com/compose/install/) (if using a `docker-compose.yml` file)
* [concourse ci prerequisites](https://concourse.ci/binaries.html) (for reference)

Other resources:
* [Concourse Hello World](https://concourse.ci/hello-world.html)
* [Extra Concourse Tutorials](https://github.com/starkandwayne/concourse-tutorial)

If you cloned this repository you can run it right out of the box with the
command `docker-compose up`. However, this is for demonstration purposes on a
local host. You will need to customize and secure the system if it is accessible
from the internet.

* Default URL: `http://localhost:8080`
* Default user: `myuser`
* Default password: `mypass`

>Note: There is a known issue with Docker's file system that may cause the
Concourse worker to consume an excessive amount of disk space when it's run
inside of a container. This can be avoided by running the worker directly on
the host. The web and postgres containers should not be affected by this issue.

### Linode / Custom kernels

Concourse CI seems to be picky about the kernel that it runs on; it can fail to
start or have unpredicitable behavior when not using the distribution's kernel.
You can check the version of your kernel with:

```text
uname -r
```

If you're using a [Linode](https://www.linode.com/) host you'll probably see
something like `4.0.4-x86_64-linode57`, which means the server is running
Linode's custom kernel. Follow Linode's guide for [running a
distribution-supplied kernel](https://www.linode.com/docs/tools-reference/custom-kernels-distros/run-a-distribution-supplied-kernel-with-kvm)
to update your kernel to be compatible with Concourse CI.

>Note: At the time of this writing the Linode guide says to install
`linux-image-virtual` from the package manager. DO NOT DO THIS, as it will
install an older 3.x version that is incompatible with Docker. The package
`linux-image-extra-4.4.0-24-generic` has been used with success.

### Generating the ssh keys

Concourse requires several ssh keys for the web server and worker to be able
to communicate. Create a directory named `keys` inside your project directory
and generate the following keys inside of it.

```text
ssh-keygen -t rsa -N '' -f host_key
ssh-keygen -t rsa -N '' -f worker_key
ssh-keygen -t rsa -N '' -f session_signing_key
```

Then copy the worker's public key to `authorized_worker_keys`.

```text
cp worker_key.pub authorized_worker_keys
```

>See the [Concourse guide for generating keys](https://concourse.ci/binaries.html)
if you wish to learn more about these keys.

### Running with docker-compose

Create a `docker-compose.yml` file in the root of the project directory. Consult
the [docker-compose reference](https://docs.docker.com/compose/compose-file/)
for help with the parameters.

```yaml
version: "2"
services:
  web:
    image: amclain/concourse-ci-web
    ports:
      - "8080:8080"
    volumes:
      - "./keys:/var/concourse/keys/"
    links:
      - db
  worker:
    image: amclain/concourse-ci-worker
    privileged: true
    volumes:
      - "./keys:/var/concourse/keys/"
    links:
      - web
  db:
    image: postgres:9.5
```

This configuration will start the web server on `http://localhost:8080`, along
with the database server and a Concourse worker. The default user is `myuser`
and the default password is `mypass`. These are also listed in
[./docker/web/Dockerfile](docker/web/Dockerfile) and
[./docker/worker/Dockerfile](docker/worker/Dockerfile). See the
[Postgres image documentation](https://hub.docker.com/_/postgres/) for
information on customizing your database.

The default environment variables can be overridden by specifying either
[environment](https://docs.docker.com/compose/compose-file/#environment) or
[env_file](https://docs.docker.com/compose/compose-file/#environment) for a
serivce in the `docker-compose.yml` file. To keep the username and password off
of the file system, we'll map the variables passed from the command line using
`environment`.

```yaml
services:
  web:
    image: amclain/concourse-ci-web
    ports:
      - "8080:8080"
    volumes:
      - "./keys:/var/concourse/keys/"
    environment:
      - USER
      - PASSWORD
    links:
      - db
# ...
```

The username and password can now be passed to the container via the command
line:

```text
USER=foo PASSWORD=bar docker-compose up
```

### Running by configuring each container (without docker-compose)

This is an advanced configuration method for Docker users who don't want to use
docker-compose. In this case it is possible to pull the images
[amclain/concourse-ci-web](https://hub.docker.com/r/amclain/concourse-ci-web/) and
[amclain/concourse-ci-worker](amclain/concourse-ci-worker) from Docker Hub and
configure them individually.

>It is recommended that you be familiar with the content in the
[Concourse Standalone Binaries](https://concourse.ci/binaries.html) guide.

```text
DATABASE

docker run --name cidb postgres

WEB

docker run --name ciweb -p 8080:8080 -p 2222:2222 --link cidb -v "/home/user/workspace/docker-concourse-ci/keys:/var/concourse/keys" -e "POSTGRES_DATA_SOURCE=postgres://postgres@cidb/postgres?sslmode=disable" ciweb

WORKER

docker run --name ciworker --link ciweb -v "/home/user/workspace/docker-concourse-ci/keys:/var/concourse/keys" -e "TSA_HOST=ciweb" --privileged ciworker
```

>* Consult the [docker run reference](https://docs.docker.com/engine/reference/run/)
for more information about these commands.
* Note that `--privileged` must be specified on the worker for it to
run correctly.

This will start the web server on `http://localhost:8080`, along with the
database server and a Concourse worker. The default user is `myuser` and the
default password is `mypass`. These are also listed in
[./docker/web/Dockerfile](docker/web/Dockerfile) and
[./docker/worker/Dockerfile](docker/worker/Dockerfile). These defaults can be
overridden by setting new values for the environment variables using `-e`. See
the [Postgres image documentation](https://hub.docker.com/_/postgres/) for
information on customizing your database.

## GitHub OAuth

It is possible to run this container using OAuth instead of basic auth by
manually configuring the container's entrypoint. This can be done on either
the command line or in the `docker-compose.yml` file, depending on which method
you are using. In this example we'll use a docker-compose file because it's
easier to read.

>See the [Concourse CI authentication guide](https://concourse.ci/authentication.html)
for configuring your GitHub account.

```yml
version: "2"
services:
  web:
    image: amclain/concourse-ci-web
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - "./keys:/var/concourse/keys/"
    links:
      - db
    entrypoint:
      "./concourse_linux_amd64 web
      --github-auth-user yourname
      --github-auth-client-id ${GITHUB_AUTH_CLIENT_ID}
      --github-auth-client-secret ${GITHUB_AUTH_CLIENT_SECRET}
      --session-signing-key /var/concourse/keys/session_signing_key
      --tsa-host-key /var/concourse/keys/host_key
      --tsa-authorized-keys /var/concourse/keys/authorized_worker_keys
      --external-url ${EXTERNAL_URL}
      --postgres-data-source postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db/${POSTGRES_DB}?sslmode=disable"
  db:
    image: postgres:9.5
    restart: unless-stopped
    volumes:
      - "./pgdata:/var/lib/postgresql/data/pgdata"
    environment:
      PGDATA: /var/lib/postgresql/data/pgdata
      POSTGRES_USER: "${POSTGRES_USER}"
      POSTGRES_PASSWORD: "${POSTGRES_PASSWORD}"
      POSTGRES_DB: "${POSTGRES_DB}"
```
