-default: watch-dev

##########
show-help: ## show help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "Defined variables:"
	@grep -E '^[a-zA-Z0-9_]+\s*=\s*[^#]*## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "\s*=\s*.*?## "}; {printf "  \033[33m%-30s\033[0m %s\n", $$1, $$2}'
##########


ELEV = npx @11ty/eleventy  --output=docs

watch-dev: ## serve dev server
	${ELEV} --serve

CLEAN-site: ## clean docs folder (CAREFUL)
	rm -rf docs
	mkdir docs

build-site: ## build site
	${ELEV}

serve-site: ## serve from docs for testing
	npx http-server docs

DEPLOY-SITE: build-site  ## DEPLOYS TO PROD
	git add -A
	git commit -m "update"
	git push origin main