name = Stable Diffusion

NO_COLOR=\033[0m	# Color Reset
COLOR_OFF='\e[0m'       # Color Off
OK_COLOR=\033[32;01m	# Green Ok
ERROR_COLOR=\033[31;01m	# Error red
WARN_COLOR=\033[33;01m	# Warning yellow
RED='\e[1;31m'          # Red
GREEN='\e[1;32m'        # Green
YELLOW='\e[1;33m'       # Yellow
BLUE='\e[1;34m'         # Blue
PURPLE='\e[1;35m'       # Purple
CYAN='\e[1;36m'         # Cyan
WHITE='\e[1;37m'        # White
UCYAN='\e[4;36m'        # Cyan
USER_ID = $(shell id -u)

all:
	@printf "$(YELLOW)==== Launch configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml up -d

help:
	@echo -e "$(OK_COLOR)==== All commands of ${name} configuration ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- make				: Run configuration"
	@echo -e "$(WARN_COLOR)- make build			: Building configuration"
	@echo -e "$(WARN_COLOR)- make conn			: Connect to container"
	@echo -e "$(WARN_COLOR)- make down			: Stopping configuration"
	@echo -e "$(WARN_COLOR)- make env			: Create environment"
	@echo -e "$(WARN_COLOR)- make git			: Set user and mail for git"
	@echo -e "$(WARN_COLOR)- make logs			: Container logs"
	@echo -e "$(WARN_COLOR)- make ps			: View configuration"
	@echo -e "$(WARN_COLOR)- make push			: Push changes to the github"
	@echo -e "$(WARN_COLOR)- make re			: Rebuild configuration"
	@echo -e "$(WARN_COLOR)- make clean			: Cleaning configuration$(NO_COLOR)"

build:
	@printf "$(YELLOW)==== Building configuration ${name}... ====$(NO_COLOR)\n"
	@bash scripts/build.sh
	@docker-compose -f ./docker-compose.yml up -d --build

conn:
	@printf "$(ERROR_COLOR)==== Connect to dash container... ====$(NO_COLOR)\n"
	@docker exec -it stable-diffusion bash

down:
	@printf "$(ERROR_COLOR)==== Stopping configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml down

env:
	@printf "$(ERROR_COLOR)==== Create environment file for ${name}... ====$(NO_COLOR)\n"
	@if [ -f .env ]; then \
		rm .env; \
	fi; \
	cp .env.example .env

git:
	@printf "$(YELLOW)==== Set user name and email to git for ${name} repo... ====$(NO_COLOR)\n"
	@bash scripts/gituser.sh

logs:
	@printf "$(YELLOW)==== postgres logs... ====$(NO_COLOR)\n"
	@docker logs stable-diffusion

ps:
	@printf "$(ERROR_COLOR)==== Stopping configuration ${name}... ====$(NO_COLOR)\n"
	@docker-compose -f ./docker-compose.yml ps

push:
	@bash scripts/push.sh

re:
	@printf "Rebuild the configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml down
	@docker-compose -f ./docker-compose.yml up -d --build

clean: down
	@printf "$(ERROR_COLOR)==== Cleaning configuration ${name}... ====$(NO_COLOR)\n"

fclean:
	@printf "$(ERROR_COLOR)==== Total clean of all configurations docker ====$(NO_COLOR)\n"
	@yes | docker system prune -a
	# Uncommit if necessary:
	# @docker stop $$(docker ps -qa)
	# @docker system prune --all --force --volumes
	# @docker network prune --force
	# @docker volume prune --force

.PHONY	: all help build down logs re ps clean fclean
