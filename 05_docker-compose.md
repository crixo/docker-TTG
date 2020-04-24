# Docker Compose

[Overview of Docker Compose](https://docs.docker.com/compose/)

## The classic voting-app
[The Voting App](https://github.com/dockersamples/example-voting-app)

## Dino sample
A [go webapp](https://learning.oreilly.com/videos/modern-golang-programming/9781787125254) using a mysql db storing the data into the host and a phpmyadmin to manage the mysql instance.  
**Build** image vs use exiting **image**
```
cd dino
docker-compose up
```

- Open the [web app](http://localhost:8080)

- Open the [phpmyadmin](http://localhost:8081) and fill the connection form w/ the following parameters:
  - mysql:3306
  - root
  - my-secret-pw

- Notice the followings:  
  - phpmyadmin access mysql using the docker compose network **dino_backend**
  ```
  docker network ls
  ```
  - mysql service uses volumes to store the data into the host filesystem (dino/datadir)
  - mysql service uses volumes to execute an init script that creates the data model and feed table w/ some testing data
  - depends_on simply drives the order used to *run* the containers. It does not wait until the related service is fully functional: depends_on is not like k8s readiness probe

- Stop the interactive shell using CTRL+C. The containers are stopped, not removed
```
docker ps -a
```

restart all containers using docker compose up or start
```
docker-compose start
```

remove all containers using docker compose
```
docker-compose down
```

datadir survives to the containers deletion
