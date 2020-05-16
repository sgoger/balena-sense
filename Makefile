.PHONY: help up down restart logs clean

# If the first argument is one of the supported commands...
SUPPORTED_COMMANDS := dc
SUPPORTS_MAKE_ARGS := $(findstring $(firstword $(MAKECMDGOALS)), $(SUPPORTED_COMMANDS))
ifneq "$(SUPPORTS_MAKE_ARGS)" ""
  # use the rest as arguments for the command
  COMMAND_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(COMMAND_ARGS):;@:)
endif

DC = docker-compose -p raspair

help: ## Display available commands
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

up: ## Start Raspair stack
	@echo "Starting Raspair stack"
	@${DC} up -d

down: ## Stop Raspair stack
	@echo "Stopping Raspair stack"
	@${DC} down

restart: ## Restart Raspair stack
	@echo "Restarting Raspair stack"
	$(MAKE) down
	@echo "Waiting a few secs for the RPI to recover"
	sleep 5
	$(MAKE) up

logs: ## Show log trail
	@echo "Showing log trail"
	@${DC} logs -f

clean: ## Clean leftovers
	@echo "Cleaning leftovers"
	@docker system prune -f

dc: ## Shortcut for docker-compose commands
	@echo "Running \"$(DC) $(COMMAND_ARGS)\""
	@${DC} $(COMMAND_ARGS)

