# Docker Workflow

## Logs management

- Show current docker log mode using docker cli
```
docker info --format '{{.LoggingDriver}}'
```

- Change docker logs through the settings menu.

[Supported docker logging drivers](https://docs.docker.com/config/containers/logging/configure/)

- Run the container in an interactive mode
```
docker run --rm -ti --name dotnetcore-api -e my-env-var=my-env-var-value -p 10001:80 dotnetcore-api:latest
```

open the [web app](http://localhost:10001) to make some api calls using swagger ui to generate logs, then show logs using docker cli
```
docker logs dotnetcore-api
docker logs dotnetcore-api -f
```

- Use docker cli to retrieve additional information including the log location on the real host
```
docker inspect dotnetcore-api
docker inspect dotnetcore-api | grep "LogPath"
```

- Jump into the windows linux VM where runs the docker engine 

old way
```
docker run --privileged --rm -it -v /var/run/docker.sock:/var/run/docker.sock jongallant/ubuntu-docker-client 

docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v /:/host alpine /bin/sh

chroot /host
```

ez way (windows & mac)
```
docker run -it --rm --privileged --pid=host justincormack/nsenter1
```

- show the log file
```
less <entry from "LogPath" within docker inspect dotnetcore-api output>
```
hit *return" to see more lines  
CTRL+C to quit

Stop&Remove the container. You'll notice the logs and the related folder are gone.

more about [Docker-In-Docker](https://blog.docker.com/2013/09/docker-can-now-run-within-docker/) and how to [interact with docker VM](https://blog.jongallant.com/2017/11/ssh-into-docker-vm-windows/)


## Understanding ENTRYPOINT and CMD

- Override the ENTRYPOINT and CMD
```
docker run --rm -ti --name dotnetcore-api --entrypoint "/bin/sh" dotnetcore-api:latest -c ls
```
Instead of running the api application, the *docker run* simply execute the command and exit

In case the dockerfile contains a [CMD command](https://github.com/alpinelinux/docker-alpine/blob/29db8d88a0387f56cc77b270f72d33b9d48fd021/x86_64/Dockerfile) simply provide the command argument(s)
```
docker run --rm -it alpine ls
```

or to simulate the previous example
```
docker run --rm -it --entrypoint "/bin/sh" alpine -c ls
```

IOW that's the same you get if you first got a shell on the alpine instance
```
docker run --rm -it alpine
```

and then from the interactive shell you type
```
/bin/sh -c ls
```

## Docker networking fundamentals

https://docs.docker.com/v17.09/engine/userguide/networking/#the-docker_gwbridge-network

- List all available networks
```
docker network ls
```

- Create a custom network
```
docker network create --driver bridge my-bridge-net
```

- Attach 2 containers to the new network
```
docker run --rm --network=my-bridge-net -itd --name=container1 alpine
docker run --rm --network=my-bridge-net -itd --name=container2 alpine
```

- Inspect container ip
```
docker inspect container2
```

- Connect to one container and ping the other by ip or name
```
docker exec -ti container1 sh
```

- Clean Up
```
docker stop container1 container2
docker network remove my-bridge-net
```

## What containers are for real?

Dive into the linux VM
```
docker run -it --rm --privileged --pid=host justincormack/nsenter1
```

Containers are first of all processes
```
ps -o pid,ppid,comm,args | grep dotnetcore
```

managed and controlled through

[NAMESPACES](https://unix.stackexchange.com/questions/105403/how-to-list-namespaces-in-linux)
```
lsns  -t pid -o ns,pid,command  | grep dotnetcore
```

and

[CGROUP](https://serverfault.com/questions/560206/how-to-find-out-cgroup-of-a-particular-process) 
```
cat /proc/{{PID}}/cgroup 
```

and 

[UnionFS](https://stackoverflow.com/questions/32775594/why-does-docker-need-a-union-file-system)  
- [Digging into Docker layers](https://medium.com/@jessgreb01/digging-into-docker-layers-c22f948ed612)
- [Explaining Docker Image IDs](https://windsock.io/explaining-docker-image-ids/)
```
docker history dotnetcore-api
docker inspect dotnetcore-api
```

Namespaces and Cgroup have *always* been out there, docker simply made easy to use it through [api & cli](https://docs.docker.com/docker-for-mac/docker-toolbox/#the-docker-desktop-on-mac-environment).  
[Enjoy the full explanation](https://vimeo.com/166694616)

## Disk space & density

```docker system df``` vs ```docker images```

