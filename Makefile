SHELL := /bin/bash

VERSION ?= 3.16
IMG := bmcustodio/iperf3
TAG := $(VERSION)

.PHONY: build push

build:
	@docker build --build-arg VERSION=$(VERSION) -t $(IMG):$(TAG) .

push:
	@docker push $(IMG):$(TAG)

run: NAME ?= iperf3
run: PORT ?= 5201
run:
	@docker run --interactive --name iperf3 --rm --tty --publish $(PORT):5201 $(IMG):$(TAG)
