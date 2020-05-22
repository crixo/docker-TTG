# docker at Torino Technologies Group

## Toolkit

- [Docker Desktop](https://www.docker.com/products/docker-desktop)  
You have to create a docker hub account

- [Docker Documentation](https://docs.docker.com/)

- [WSL](https://itnext.io/setting-up-the-kubernetes-tooling-on-windows-10-wsl-d852ddc6699c) - (Win user only) - Optional  
  Ubuntu 16.04 should be fine, but I suggest you to start with 18.04 instead.  
  Someone had issue installing docker-compose via python. [Installing it via curl](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04) works just fine.  
  WSL provides a full linux bash experience. Win users not using WSL have to adapt some commands within this tutorial and convert some scripts to the target terminal language.

## Introduction

- [Getting Started With Docker](https://dzone.com/refcardz/getting-started-with-docker-1?chapter=1)

- [Getting started with Docker](https://collabnix.com/understanding-docker-container-image/)

- (Virtual Machine VS Container)[https://medium.com/@deshanigeethika/docker-tutorial-a6aa5b41e3ff]

- (container vs docker)[https://www.opencontainers.org/]

- [Understanding Docker Container Architecture](https://medium.com/docker-captain/docker-basics-f1a06fde18fb)

- [The twelve-factor app](https://12factor.net/)

## Docker basic workflow

- Understanding the Dockerfile and the multistage build approach

- Build an image

- Run a container understanding port forwarding and environment variables

- Interact with a running container

- Create an image from a running container

- Stop a running container

- Play with the container registry

Try all the steps using the [dotnetcore api sample](02_docker-workflow.md)

## Managing files and data

- Share files between host and container

- Stateful app

- Container as development environment

Try all the steps using the [volumes sample](03_volumes.md)

## Advanced topics

- Logs management

- Understanding ENTRYPOINT and CMD

- Docker networking fundamentals

- What containers are for real?

Try all the steps using the [advanced sample](04_advanced.md)

## Local orchestration with docker-compose

- The classic voting app sample

- Dino sample

Try all the steps using the [docker compose sample](05_docker-compose.md)

## CI/CD examples

- Deploy a docker app using azure webapp

- github + travis + heroku

Try all the steps using the [deploy docker image to an azure webapp](06_deploy-image-to-webapp.md)