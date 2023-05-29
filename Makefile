start:
	docker-compose up -d --no-recreate --remove-orphans

create: stop
	docker-compose build --force-rm
	docker-compose up -d --force-recreate

stop:
	docker container stop $$(docker container ps -qa)

build-source:
	docker-compose exec server composer self-update
	docker-compose exec server symfony new --webapp --version="6.3.*" .

build-backend:
	docker-compose exec backend composer self-update
	docker-compose exec backend symfony new --webapp --version="6.2.*" .

build: build-source

install: create build

enter: 
	docker-compose exec server bash

ps: 
	docker-compose ps