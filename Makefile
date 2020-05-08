.PHONY: help up down restart logs clean

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
	@${DC} prune -f