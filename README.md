# docker at Torino Technologies Group

## Toolkit

-  [Docker Desktop](https://www.docker.com/products/docker-desktop)  
You have to create a docker hub account

-  [Docker Documentation](https://docs.docker.com/)

## Introduction

- [Getting Started With Docker](https://dzone.com/refcardz/getting-started-with-docker-1?chapter=1)

-  [Getting started with Docker](https://collabnix.com/understanding-docker-container-image/)

- (Virtual Machine VS Container)[https://medium.com/@deshanigeethika/docker-tutorial-a6aa5b41e3ff]

- (container vs docker)[https://www.opencontainers.org/]

- [Understanding Docker Container Architecture](https://medium.com/docker-captain/docker-basics-f1a06fde18fb)

- [The twelve-factor app](https://12factor.net/)

## Docker basic workflow

-  Understanding the Dockerfile and the multistage build approach

-  Build an image

-  Run a container understanding port forwarding and environment variables

-  Interact with a running container

-  Create an image from a running container

-  Stop a running container

-  Play with the container registry

Try all the steps using the [dotnetcore api sample](02_docker-workflow.md)

## Managing files and data

-  Share files between host and container

-  Stateful app

-  Container as development environment

Try all the steps using the [volumes sample](03_volumes.md)

## Advanced topics

-  Logs management

-  Understanding ENTRYPOINT and CMD

-  Docker networking fundamentals

Try all the steps using the [advanced sample](04_advanced.md)

## Local orchestration with docker-compose

-  The classic voting app sample

-  Dino sample

Try all the steps using the [docker compose sample](05_docker-compose.md)

## CI/CD examples

-  Deploy a docker app using azure webapp

-  github + travis + heroku

Try all the steps using the [deploy docker image to an azure webapp](06_deploy-image-to-webapp.md)