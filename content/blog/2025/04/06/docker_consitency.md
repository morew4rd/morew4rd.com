---
title: Docker for consistency
date: 2025-04-06T09:30
# draft: true
---

## Docker and docker-compose

I run all my non-static sites/webapps on a small VPS. I have very little installed on the VPS. For example, although most of my sites are node.js these days, I don't have node or npm installed there. But I do I do have `docker` along with `make` and `git` installed.

## VPS use

Sites, DBs, helpers (like monitoring tools) all run in docker containers, and are kept up via `docker compose`. This is sort of a setup-and-forget thing for the most part which is nice. But see [the beware section below](#beware) for some warnings!

## Devbox use for web dev

Since I use the same image locally on my MacBook, my test environment during development is mostly a good representative of livesite environment.

## Consistent builds for native dev

This also applies for projects that need build steps. Same build runs on my macbook and github CIs, for example. You can build Linux or Windows binaries (via mingw) or WASM (via emscripten) from a single image!

## Use for older libc linking

Standard practice in linux is to dynamically link your apps against the system libc. However, there re good use cases for static linkink as well. The trouble is this is not well supported. If you, for example build and statically link your app in Ubuntu 24.04, there's a chance that you can't run it on Ubuntu 20.04 or other distros with different libc builds.

In this case, just use a Docker based on Ubuntu 18 or whatever minimum you'd like to match.

Lyte2D builds use this mechanism to get a broader set of linux distributions supported with a single binary.

(Though there seems to be [a new sort of solution](https://jangafx.com/insights/linux-binary-compatibility) that I should investigate.)

## Beware

- Open ports & security concerns: Unfortunately whenever you open a port for your container it makes a hole in your host system's firewall. Some [reddit notes](https://www.reddit.com/r/selfhosted/comments/1cv2l3q/security_psa_for_anyone_using_docker_on_a/?rdt=53453). There are workarounds with various tradeoffs. I personally chose to disable iptables completely for docker on my VPS. (Ask me if you need more details.)
- OOMs: Docker constainers have default limitations for memory use. And if you pass them your image gets killed. Keep this in mind for your testing strategy

## Alternatives?

- You can run things on the host. Could be managable but can get chaotic. Easier to make mistakes.
- You can use something like Nix (you'd love this one if you're a Rust or Haskell person, for example.)
- You can use VMs (but these would be more expensive both in $$$ and in time.)

I personally found Docker (+ [make](/blog/2025/04/05/makefile_scripting/)) to be a sweet spot for a high capacity/complexity ratio.
