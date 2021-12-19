SERVER = vip_salah_2021-server
GIT = git@gitlab.com:dockerized1/symfony6_skeleton.git
CODEBASE = ./codebase
EXEC = docker exec -it $(SERVER)
# Use it only when want to delete all containers and images
uninstall: stop
	docker container rm $$(docker container ps -aq)
	docker system prune
	docker image prune
	docker network prune
# Remove the base dir of the project
remove-dir:
	rm -Rf $(CODEBASE)
# Create the project folder
create-project-directory:
	mkdir $(CODEBASE)
# Access to the PHP container
enter:
	$(EXEC) bash
# Run without recreation
start:
	docker-compose up -d --no-recreate --remove-orphans
# Stop all containers
stop:
	docker-compose stop
	docker container stop $$(docker container ps -aq)
# List all containers
list:
	docker-compose ps
# Create basic project using composer
composer-create-project:
	$(EXEC) composer create-project symfony/website-skeleton .
# Start all containers with build and force recreate flags
force-recreate:
	docker-compose up -d --build --force-recreate
# Create the working dir + starting all containers
install: create-project-directory force-recreate list
 # Clone project from Git.
clone-project: install
	git clone $(GIT) $(CODEBASE)
# Run the composer install command
composer-install:
	cd $(CODEBASE) && $(EXEC) composer install
# Run a build
build:
	docker-compose build
# Start Web server
start-server:
	docker-compose up -d server
	
# Performs the PHPSTAN check of a given file/directory. To use this, run make run-stanr file=<dir/file name>
run-stan:
	docker exec -it $(SERVER) vendor/bin/phpstan analyse $(file) --level=8 -c phpstan.neon

# Performs CSFIXER check of a given file/directory. To use this, run make  run-csfixer file=<dir/file name>
run-csfixer:
	docker exec -it $(SERVER) vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix $(file) --dry-run --diff --config=.php-cs-fixer.dist.php
	
# Restore LF file ending to all files
lf:
	cd $(CODEBASE) && git config core.autocrlf false && git rm --cached -r . && git reset --hard
