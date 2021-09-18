SERVER = atelier_php8_2021-server
GIT = git@gitlab.com:dockerized1/symfony6_skeleton.git
CODEBASE = ./codebase
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
	rm -Rf $(CODEBASE)
# Create the project folder
create-project-directory:
	mkdir $(CODEBASE)
# Access to the PHP container
enter:
	docker exec -it $(SERVER) bash
# Run without recreation
run:
	docker-compose up -d --no-recreate --remove-orphans
# Stop all containers
shut-down:
	docker-compose stop
	docker container stop $$(docker container ps -aq)
# List all containers
list:
	docker-compose ps
# Create basic project using composer
composer-create-project:
	composer create-project symfony/website-skeleton $(CODEBASE)
# Start all containers with build and force recreate flags
force-recreate:
	docker-compose up -d --build --force-recreate
# Create the working dir + starting all containers
install: create-project-directory force-recreate list
 # Clone project from Git.
clone-project: install
	git clone $(GIT) $(CODEBASE)
access-project:
	cd $(CODEBASE)
# Run the composer install command
composer-install: access-project
	composer install