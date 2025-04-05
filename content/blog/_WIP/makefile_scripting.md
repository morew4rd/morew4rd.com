---
title: Makefile For Scripting, Dockerfile For Repeatability
date: 2025-04-05T00:00
draft: true
---

## DRAFT TBD
- remove "learn" but provide links
- screenshots
- explanation of .PHONY
- default target
- dependencies
- ...


## 'make' and Makefiles

What's a Makefile? Well if you don't know that, go find it out, come back.

But what a "scripting oriented" makefile? Instead of using Makefile to directly build "files" as its created intended, we'll just stick to using other tools for that. We'll use makefile target's only for scripting/orchestrating builds/deployments/etc.

The example below tells a way to do this. But you can of course invent your own way.

## Example "scripting oriented" makefile

```make
-default: show-help

show-help: ## show targets and variables
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "Defined variables:"
	@grep -E '^[a-zA-Z0-9_]+\s*=\s*[^#]*## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "\s*=\s*.*?## "}; {printf "  \033[33m%-30s\033[0m %s\n", $$1, $$2}'


BUILD_DIR = _b 	## build output directory

clean-test: ## clean test build
	rm -rf ${BUILD_DIR}

config-test: ## configure tests
	mkdir -p ${BUILD_DIR}

build-test: ## build tests
	cc -o ${BUILD_DIR}/test -I src src/apic.c test/test.c

run-test: clean-test config-test build-test ## rebuild and run test
	${BUILD_DIR}/test > ${BUILD_DIR}/a.txt
	cat ${BUILD_DIR}/a.txt
```

