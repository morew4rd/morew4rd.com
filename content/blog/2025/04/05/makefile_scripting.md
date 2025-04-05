---
title: Makefiles for scripting
date: 2025-04-05T00:00
---

GNU `make` is an old tool designed to build C codebases. I don't use it for that purpose though. For projects that are larger than a few files, I just pull cmake these days.

But... make itself is still very useful to get basic scripting going in my codebases and elsewhere.

I use Makefiles to

- Call cmake/zig build/npm etc with various options to build projects
- Execute tests
- Build/run docker images
- Deploy sites and apps
- And more...

## Basics of make

So how do you use it? You'd typically use it with a dev project, so let's assume you're in your project's top level directory:

- You write a `Makefile`, like the one below
- Call the default target with `make`
- Call any other target with `make config-test`
- Override variables with `make build-tests BUILD_DIR=../tmp/test`

Here's a very simple example:

```Makefile
# Makefile comments start with a `#` and run till the end of the line.

# Targets are defined with a name and a colon.  First ever target in the file is the "default"
# It is the target that runs if there are no arguments passed to `make`.
# The dependencies of the target are listed after the colon, whitespace separated
# Those are executed before the target tasks
# Tasks that the target will run in cmdline, one by one, are listed below the target name, indented with `tab`s (not spaces!)

my-default-target: run-tests
	echo "done."

# You can define variables like so
# You can override these varibles from command line while invoking make.

BUILD_DIR = ./_build

# Some other targets below:

clean-test:
	rm -rf ${BUILD_DIR}

config-test:
	mkdir -p ${BUILD_DIR}

build-test:
	cc -o ${BUILD_DIR}/test -I src src/apic.c test/test.c

# This is the target that `my-default-target` depends on.
# And it depends on a few others.

run-test: clean-test config-test build-test
	${BUILD_DIR}/test > ${BUILD_DIR}/a.txt
	cat ${BUILD_DIR}/a.txt

```

The idea is, instead of many script files, all scripting tasks are contained in a single location. In zsh (and others probably) you can get a tab completion for the target names, so it's very comfy.

## Be careful with "weird" parts

- Indentation should be done with tabs. Editors usually are aware of this, at least vscode is.
- Target names should not match the files in the folder where Makefile resides. This is due to the fact that `make` is actually made to build `NAME.c` files. If you have to have targets matching filenames, look up `.PHONY` targets. In order to keep things simple, I use a `-` in my target names and I almost never have filenames with that.

## Advanced: zsh tab completions

Add the following in your `~/.zshrc`:

```sh
# makefile completions
autoload -Uz compinit
compinit
# only makefile targets, not files!
zstyle ':completion::complete:make::' tag-order targets variables
```

## Advanced: `show-help` target

See this example, it's actually this blog's current `Makefile`:

```make
-default: watch-dev

##########
show-help: ## show help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo "Defined variables:"
	@grep -E '^[a-zA-Z0-9_]+\s*=\s*[^#]*## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = "\s*=\s*.*?## "}; {printf "  \033[33m%-30s\033[0m %s\n", $$1, $$2}'
##########


ELEV = npx @11ty/eleventy  --output=docs

clean-site: ## clean docs folder (CAREFUL)
	rm -rf docs
	mkdir docs

watch-dev: clean-site ## serve dev server in watch mode
	${ELEV} --serve

build-site: clean-site ## build site
	${ELEV}

serve-site: ## serve from docs for testing
	npx http-server docs

DEPLOY-SITE: build-site  ## DEPLOYS TO PROD
	git add -A
	git commit -m "update"
	git push origin main
```

In this version, we have a `show-help` target which is also set to display the list of targets and variables with some shell magic.  All the targets and variables that have `## ...` comments after them will be listed, along with the comment, which is supposed to be the help text for that target/variable.

```sh
mg ~/code/morew4rd.com $ make show-help
Available targets:
  DEPLOY-SITE                    DEPLOYS TO PROD
  build-site                     build site
  clean-site                     clean docs folder (CAREFUL)
  serve-site                     serve from docs for testing
  show-help                      show help
  watch-dev                      serve dev server in watch mode
```
