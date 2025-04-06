---
title: Docker for consistency
date: 2025-04-06T09:30
draft: true
---

## Docker and docker-compose

I run all non-static sites on a small VPS. I have very little installed on the VPS. For example, although most of my sites are node.js these days, I don't have node or npm installed there. But I do I do have `docker` along with `make` and `git` installed.

Sites, DBs, helpers (like monitoring tools) all run in docker containers, and are kept up via `docker compose`

I use docker locally on my macbook too.

And I automate builds and deploys via `make` ([I talked about this yesterday](/blog/2025/04/05/makefile_scripting/)).


## Use for linux/mingw builds (DI or local)

## Use for older libc linking (link to ginger bill's tweet)

## Beware

- Open ports vs ufw
- OOMs


