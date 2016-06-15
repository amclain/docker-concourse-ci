# docker-concourse-ci

A set of [Docker](https://www.docker.com/) containers that run [Concourse CI](https://concourse.ci/).

The easy way:
```text
docker-compose up
```

The harder way:
```text
DATABASE

docker run --name cidb postgres

WEB

docker run --name ciweb -p 8080:8080 -p 2222:2222 --link cidb -v "/home/alex/workspace/docker-concourse-ci/keys:/var/concourse/keys" -e "POSTGRES_DATA_SOURCE=postgres://postgres@cidb/postgres?sslmode=disable" ciweb

WORKER

docker run --name ciworker --link ciweb -v "/home/alex/workspace/docker-concourse-ci/keys:/var/concourse/keys" -e "TSA_HOST=ciweb" --privileged ciworker
```



