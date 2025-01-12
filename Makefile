DOCKER_COMPOSE_RUN := docker-compose run --rm

ifndef BUILD_VERSION
override BUILD_VERSION = 0.0.0
endif

ifndef ENVFILE
override ENVFILE = .env
endif

build: _env
	$(DOCKER_COMPOSE_RUN) 3m make _build
.PHONY: build

_build:
	/usr/bin/docker build \
	  -t docker.io/whateverany/matrix-mc:$(BUILD_VERSION) \
	  -f src/Dockerfile  \
	  .
.PHONY: _build

shell: _env
	$(DOCKER_COMPOSE_RUN) 3m /bin/sh
.PHONY: shell

shell-test: _env
	docker run -it --entrypoint /bin/sh whateverany/matrix-mc:$(BUILD_VERSION)
.PHONY: shell-test

_env:
	echo "INFO: checking for ENVFILE=$(ENVFILE)"
	if [ -e $(ENVFILE) ] ; then \
	  echo "INFO: ENVFILE=$(ENVFILE) exists" ;\
	else \
	  echo "INFO: ENVFILE=$(ENVFILE) does not exist" ;\
	  touch $(ENVFILE) ;\
	  $(DOCKER_COMPOSE_RUN) 3m_init make __env ;\
	fi
.PHONY: _env

__env:
	echo "INFO: creating ENVFILE=$(ENVFILE)"
	echo "_DOCKER_HOME=/home/user/.docker" >> $(ENVFILE)
.PHONY: __env
