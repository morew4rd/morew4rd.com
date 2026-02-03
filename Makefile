-default: watch-dev

ls-targets: ## list available targets (this list)
	@echo "Available targets:" && grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
################################################################################################################################################################################

RIMRAF = npx rimraf
MKDIR = mkdir
SERVER = npx http-server

ELEV = npx @11ty/eleventy  --port 9999 --output=docs

clean-site: ## clean docs folder (CAREFUL)
	$(RIMRAF) docs
	$(MKDIR) docs

watch-dev: clean-site ## serve dev server in watch mode
	$(ELEV) --serve

build-site: clean-site ## build site
	$(ELEV)

serve-site: ## serve from docs for testing
	$(SERVER) docs

DEPLOY-SITE: build-site  ## DEPLOYS TO PROD
	git add -A
	git commit -m "update"
	git push origin main