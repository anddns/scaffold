# Run Artisan commands
function artisan_cli () {
   docker compose run --rm backend php artisan $1
}

# Run Composer commands
function composer_cli () {
   docker compose run --rm backend composer $1
}

# Run NPM commands
function npm_cli () {
   docker compose run --rm frontend npm $1
}

# Build containers from images
function build_container () {
   docker compose build $1
}

# Stop and erase container
function down_container () {
   docker compose down $1
}

# Start all containers
function start_container () {
   docker compose up -d
}

# Stop all containers
function stop_container () {
   docker compose stop
}

# Restart all containers
function restart_container () {
   stop_container && start_container
}

# Erase the containerized environment completely
function destroy_containers () {
   read -p "This will delete containers, volumes and images. Are you sure? [y/N]: " -r
   if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit; fi
   docker compose down -v --rmi all --remove-orphans
}

# Display container logs
function logs_container () {
   docker compose logs -f $1
}

# Create a '.env' file from '.env.example'
function env_create () {
    if [ ! -f .env ]; then
        cp .env.example .env
    fi
}

# Initialise containerized environment and the application
function init_scaffold () {
    env \
        && down_container -v \
        && build_container \
        && docker compose run --rm --entrypoint="//opt/files/init.sh" backend \
        && npm_cli install \
        && start_container
}

# Update the containerized environment
function update_scaffold () {
    git pull \
        && build_container \
        && composer_cli install \
        && artisan_cli migrate \
        && npm_cli install \
        && start_container
}