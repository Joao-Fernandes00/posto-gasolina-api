COMPOSE=docker compose
APP=$(COMPOSE) run --rm api
APP_TEST=$(COMPOSE) run --rm -e RAILS_ENV=test api

.PHONY: build setup db-create db-migrate seed routes test server down console

build:
	$(COMPOSE) build

setup:
	$(COMPOSE) build
	$(APP) bundle exec rails db:create db:migrate db:seed

db-create:
	$(APP) bundle exec rails db:create

db-migrate:
	$(APP) bundle exec rails db:migrate

seed:
	$(APP) bundle exec rails db:seed

routes:
	$(APP) bundle exec rails routes

test:
	$(APP_TEST) bundle exec rails test

server:
	$(COMPOSE) up api

console:
	$(APP) bundle exec rails console

down:
	$(COMPOSE) down
