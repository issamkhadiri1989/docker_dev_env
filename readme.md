# Installation
The following commands are available for the make command. 

Before using them, make sure you had already configured the `SERVER` container name and `GIT` repository.  
```
SERVER = atelier_php8_2021-server
GIT = git@gitlab.com:dockerized1/symfony6_skeleton.git
```
The variable `CODEBASE` should remain the same to run all containers without errors.

## uninstall
Stops all containers. It performs prune to all containers/images and networks
```
uninstall: shut-down
	docker container rm $$(docker container ps -aq)
	docker system prune
	docker image prune
	docker network prune
```
## remove-dir
It deletes the codebase folder
```
remove-dir:
	rm -Rf $(CODEBASE)
```
## create-project-directory
It creates the main codebase directory
```
create-project-directory:
	mkdir $(CODEBASE)
```
It will cause an error if the folder already exists. Use the command below to delete and recreate 
```make remove-dir && make create-project-directory```
## enter
This command is use to access the server's container defined with the variable `SERVER`

```
enter:
	docker exec -it $(SERVER) bash
```
## run
Runs all containers based on the docker-compose.yml file, It is ran with `--no-recreate` and `--remove-orphans` flags.
```
run:
	docker-compose up -d --no-recreate --remove-orphans
```
## shutdown
It turns off all containers.
```
shut-down:
	docker-compose stop
	docker container stop $$(docker container ps -aq)
```
## list
Lists all containers and their state
```
list:
	docker-compose ps.
```
## composer-create-project
This will create a symfony based project using the `composer create-project` command
```
composer-create-project:
	composer create-project symfony/website-skeleton $(CODEBASE)
```
## force-recreate:
This command will rebuilt all containers with `--build` flag. Then, it starts them with `--force-recreate flag` 
```
force-recreate:
	docker-compose up -d --build --force-recreate
```
## install
This command will  install the project from scratch. 
First, it will create the project main folder which is set in the `CODEBASE` variabe, Then, it calls the `force-recreate` command to perform a force recreation of the all containers. Finally, it lists all containers to view their state
```
install: create-project-directory force-recreate list
```
If the main directory exists, it prints an error. To force deletion of the existing directory, run the following command: 
``` make remove-dir && make install```
## clone-project
This will clone the project from the repository set in the varibale `GIT`. Then, install the projet qwith the `install` command
```
clone-project: install
	git clone $(GIT) $(CODEBASE)
```
## composer-install
It runs the `composer install` inside the main prject directory already set in the `CODEBASE` variable
```
composer-install:
	cd $(CODEBASE) && composer install
```
## build
It runs a build of all containers
```
build:
	docker-compose build
```

## run-stan
It runs a PHPSTAN analysis for a given file/directory. To run it just tape: Make run-stan file=<file/directory path>
```
run-stan:
	docker exec -it $(SERVER) vendor/bin/phpstan analyse $(file) --level=8 -c phpstan.neon
```

## run-csfixer
It runs a CS FIXER analysis for a given file/directory. To run it just tape: Make run-csfixer file=<file/directory path>
```
run-csfixer:
	docker exec -it $(SERVER) vendor/friendsofphp/php-cs-fixer/php-cs-fixer fix $(file) --dry-run --diff --config=.php-cs-fixer.dist.php
```


## lf
Restores LF file endings. USE IT ONLY IF THE gitbash has changed the endings
```
lf:
	cd $(CODEBASE) && git config core.autocrlf false && git rm --cached -r . && git reset --hard
```


---
# XDEBUG  CONFIGURATION

## File xdebug.ini
```
variables_order=EGPCS
xdebug.mode=develop,debug
xdebug.client_port=9003
xdebug.idekey=PHPSTORM
xdebug.max_nesting_level = 250
max_execution_time = 300
xdebug.start_with_request=yes
xdebug.log_level=1
xdebug.client_host=host.docker.internal
xdebug.remote_handler=dbgp
xdebug.discover_client_host=1
```

## File docker-php-ext-xdebug.ini
```
zend_extension=xdebug
```

## PHPSTORM
```
PHP ➝ Debug
	Xdebug section : 
		- Debug port: 9000,9003
		
		all checkboxes must be checked

PHP ➝ Servers
	🠾 Create a new server 
		- Name  : xxx
		- Host  : localhost
		- Port  : 80
		- Debugger: Xdebug
		
		Check the "Use path mappings" option
		then, map the local project repository with the one  in the container
		For exemple 
			File/Directory : C:\htdocs\symfony_certifications\codebase
			Absolute path on the server : /var/www/html
			
PHP ➝ Debug ➝ DBGp Proxy
	IDE key : PHPSTORM
	Host    : localhost
	Port    : 80
	
	
In the Run/Debug: Edit Configuration 
	🠾 Add new PHP Remote Debug 
            | Name     : remote_debugger
            | Server   : xxx
            | IDE key  : PHPSTORM
```

## VS CODE
```
{
    "version": "0.2.0",
    "configurations": [
        
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "runtimeArgs": [
                "-dxdebug.mode=debug",
                "-dxdebug.start_with_request=yes"
            ],
            "env": {
                "XDEBUG_MODE": "debug,develop",
                "XDEBUG_CONFIG": "client_port=${port},idekey=PHPSTORM"
            },
            "hostname": "localhost",
            "pathMappings": {
                "/var/www/html/": "${workspaceFolder}"
            }
        }
    ]
}
```
