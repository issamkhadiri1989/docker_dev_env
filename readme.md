# Run the Workshop development environment
The following are the main command lines that you will need to run the env dev. 

## Build and run containers: 
run `docker-compose up -d --build` to build and run the  development environment if it is the first time.

## Run development environment without recreate
run `docker-compose up -d --no-recreate --remove-orphans` if you want to start your containers without recreating. 
containers.

## Stop all containers
run `docker container stop $(docker container ps -aq)` to stop all containers.