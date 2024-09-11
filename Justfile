# Execute php on phpfpm container
php +ARGS:
    @docker compose exec -u $(id -u) phpfpm php {{ARGS}}

# Execute composer on phpfpm container
composer +ARGS:
    @docker compose exec -u $(id -u) phpfpm composer {{ARGS}}

# Shortcut for console on DEV environment
console +ARGS:
    just php bin/console {{ARGS}}

# Execute yarn on webpack container
yarn +ARGS:
    @docker compose run webpack yarn {{ARGS}}
