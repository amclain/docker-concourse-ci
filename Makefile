build:
	@ ${MAKE} build-web
	@ ${MAKE} build-worker

build-web:
	docker build -t amclain/concourse-ci-web ./docker/web

build-worker:
	docker build -t amclain/concourse-ci-worker ./docker/worker
