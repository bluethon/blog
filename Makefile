.PHONY: .ONESHELL build test up down start

.ONESHELL:

SHELL=/bin/bash
.DEFAULT_GOAL := start

%: export COMPOSE_PROJECT_NAME =

CMD=-h
test:
	docker-compose ${CMD}

subupdate:
	git submodule update
server:
	hugo server -D
build:
	export HUGO_ENV=production
	hugo --gc --minify

start: build
