SERVER = symfony_project_2021-server

# Use it only when want to delete all containers and images
uninstall:
	docker-compose stop
	docker container stop $$(docker container ps -aq)
	docker container rm $$(docker container ps -aq)
	docker system prune
	docker image prune
	docker network prune
	docker-compose ps
	rm -Rf codebase

# Remove the base dir of the project
remove-dir:
	rm -Rf codebase

# Access to the PHP container
enter:
	docker exec -it $(SERVER) bash

# Run without recreation
run:
	docker-compose up -d --no-recreate --remove-orphans
	docker-compose ps

# Stop all containers
stop:
	docker-compose stop
	docker container stop $$(docker container ps -aq)

# List all containers
list:
	docker-compose ps

# Create basic project using composer
create-project:
	composer create-project symfony/website-skeleton ./codebase

# Install the project from Git
install:
	mkdir codebase && docker-compose up -d --build --force-recreate && docker-compose ps && git clone git@gitlab.com:dockerized1/symfony6_skeleton.git ./codebase && cd codebase && composer install