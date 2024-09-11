all: help

help: ## Show help
	@grep -E '(^[a-zA-Z0-9_\-\.]+:.*?##.*$$)|(^##)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

####################
## Install / Dev  ##
####################

install: ## Installs application
	make image.pull
	make image.build
	make start
	make composer.install
	make yarn.install
	make db.reset

image.pull: ## Pulls all images
	docker compose pull

image.build: ## Builds all images
	docker compose build

composer.install: ## Installs composer dependencies
	just composer install

yarn.install: ## Installs yarn dependencies
	just yarn install

####################
##  Start / Stop  ##
####################

start: ## Start the containers
	docker compose up -d

stop: ## Stop the containers
	docker compose down --remove-orphans

restart: ## Restart the containers
	make stop
	make start

rebuild: ## Restart and rebuild the containers
	make stop
	make image.build
	make start

webpack:
	docker compose stop webpack
	docker compose up webpack

in: ## Enter php container with zsh
	make start
	docker compose run -it phpfpm zsh

####################
##      App      ##
####################

entity: ## Create entity
	just console make:entity

controller: ## Create controller
	just console make:controller

crud: ## Create Easy Admin CRUD
	just console make:admin:crud

migration: ## Create migration
	just console make:migration

cache_clear: ## Clear symfony cache
	just console cache:clear

debug: ## Start dump server
	just console server:dump

####################
##      Tests     ##
####################

test.init: ## Init for testing
	docker compose exec -e APP_ENV=test phpfpm bin/console doctrine:database:drop --force --if-exists
	docker compose exec -e APP_ENV=test phpfpm bin/console doctrine:database:create
	docker compose exec -e APP_ENV=test phpfpm bin/console doctrine:migrations:migrate --no-interaction
	docker compose exec -e APP_ENV=test phpfpm bin/console doctrine:fixtures:load --no-interaction --group=tests

test.run: ## Init and run tests
	make test.init
	docker compose exec -e APP_ENV=test phpfpm bin/phpunit --coverage-html coverage
	docker compose exec phpfpm chmod -R 777 coverage
	docker compose exec phpfpm chown -R $(id -u): coverage

test.run-quick: ## Run tests
	docker compose exec -e APP_ENV=test phpfpm bin/phpunit --coverage-html coverage
	docker compose exec phpfpm chmod -R 777 coverage
	docker compose exec phpfpm chown -R $(id -u): coverage

test.cache_clear: ## Clear symfony test cache
	docker compose exec -e APP_ENV=test phpfpm bin/console cache:clear

#####################
## Static analysis ##
#####################

static.phpcpd: ## Run PHPCPD
	docker compose exec phpfpm ./vendor/bin/phpcpd ./src --exclude ./src/Entity --exclude ./src/DataFixtures

static.phpstan: ## Run PHPSTAN
	docker compose exec phpfpm ./vendor/bin/phpstan analyse ./src -c phpstan.dist.neon

static.lint: ## Run PHPCS without fixing
	docker compose exec phpfpm ./vendor/bin/php-cs-fixer fix --dry-run

static.lint.fix: ## Run PHPCS with fixing
	docker compose exec phpfpm ./vendor/bin/php-cs-fixer fix

static.twig.lint: ## Run twig linter
	just console lint:twig templates

static.yaml.lint: ## Run yaml linter
	just console lint:yaml translations config

static.translation.lint: ## Run twig linter
	just console debug:translation --only-missing --domain=messages fr

static.security_check: ## Check if known vulnerabilities in dependencies
	just composer audit --no-dev

static.webpack.lint: ## Run ts linter
	docker compose run webpack yarn run lint:fix
	docker compose run webpack yarn run lint:scss
	docker compose run webpack yarn run prettier:fix

static.php: ## Run php static tests
	make static.phpcpd
	make static.phpstan
	make static.lint.fix

static.extra: ## Run extra validation rules
	make static.twig.lint
	make static.yaml.lint
	make static.translation.lint

static.run: ## Run static tests
	make static.php
	make static.webpack.lint
	make static.extra

####################
##    Database    ##
####################

db.migrations.migrate: ## Execute database migrations
	docker compose exec phpfpm php bin/console doctrine:migrations:migrate

db.migrations.diff: ## Generate database migration
	docker compose exec phpfpm php bin/console doctrine:migrations:diff

db.migrations.generate: ## Generate blank database migration
	docker compose exec phpfpm php bin/console doctrine:migrations:generate

db.migrations.list: ## List all database migrations
	docker compose exec phpfpm php bin/console doctrine:migrations:list

db.migrations.down: ## Revert last database migration
	docker compose exec phpfpm bin/console do:mi:mi prev --no-interaction -v

db.reset:
	docker compose exec phpfpm bin/console doctrine:database:drop --force --if-exists
	docker compose exec phpfpm bin/console doctrine:database:create
	docker compose exec phpfpm bin/console doctrine:migrations:migrate --no-interaction

####################
##      Logs      ##
####################

logs.watch: ## Display containers logs
	docker compose logs -f

log.clean:
	docker compose exec phpfpm rm -rf var/log/*

####################
##    Pipeline   ##
####################

run.pipeline: ## Run pipeline tests
	make static.run
	make static.security_check
	make test.run
