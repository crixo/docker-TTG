# Managing files and data

## Share files between host and container

### Copy file explicitly
run a container into a separate shell
```
docker run --rm --name copy-sample -ti alpine:3.8
```

open a second terminal

prepare the file and scripts
```
echo "foo file content" > foo.txt
CNT_NAME_OR_ID=copy-sample
```

Copy a file from host to container:
```
docker cp foo.txt $CNT_NAME_OR_ID:/foo.txt
```

remove the file on host
```
rm foo.txt
```

Copy a file from Docker container to host:
```
docker cp $CNT_NAME_OR_ID:/foo.txt foo.txt
```

show the file added into the container filesystem.  
switch to the first terminal andrun the following command from the container shell
```
ls
```

Clean Up
```
rm foo.txt
docker stop $CNT_NAME_OR_ID
```

### Use volumes
windows only
```
pattern=/c/
replace="c:/"
PWD=${PWD/$pattern/$replace}
echo $PWD
```

run the container setting up a volume to share files between container and host
```
docker run --rm --name copy-sample -v $PWD:/my-volume -ti alpine:3.8
```

navigate to the /my-volume folder through the interactive shell provided by the running container
```
cd /my-volume
ls
```
you can browse host files as part of the container filesystem.  
Create a file on the container filesystem using the container interactive shell
```
touch foo.txt
```
you'll see the file on host filesystem as well

Clean Up
```
rm foo.txt
docker stop $CNT_NAME_OR_ID
```

## Stateful app
run mongodb in a container
```
docker run --rm -d -p 27017:27017 --name mongo-d3-lab -e MONGODB_DATABASE=rsvpdata  -e COMPANY=deltatre mongo:3.3
```
You can connect to mongo instance running within the container using any mongo client.  

The database data lives within the container itself
```
docker exec -ti mongo-d3-lab /bin/sh
```

windows bash requires escaping the command
```
docker exec -ti mongo-d3-lab //bin/sh
```

from the container shell
```
cd /data/db 
ls
```

Run the container configuring a volume to store the database data on the host instead into the container
```
docker run --rm -d -p 27017:27017 --name mongo-d3-lab -e MONGODB_DATABASE=rsvpdata -v $PWD/mongodata:/data/db  -e COMPANY=deltatre mongo:3.3
```

[why is not working on Windows](https://hub.docker.com/_/mongo) while now works on [OS X](https://stackoverflow.com/questions/29570989/docker-mongodb-share-volume-with-mac-os-x)

Build the image of the [python app](https://github.com/cloudyuga/rsvpapp) using the mongo container
```
cd rsvpapp-master
docker build -t python-app .
```

Get host ip address
```
Get-NetIPAddress -AddressFamily IPv4

# windows bash
ipconfig | grep -A 5 Wi-Fi | grep "IPv4 Address"
HOST_IP=$(ipconfig | grep -A 5 Wi-Fi | grep -E -o -m 1 "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

ip addr show

ipconfig getifaddr en0

HOST_IP=$(ipconfig getifaddr en0)
```

Run the mongo container w/o the --rm flag and w/o volume
```
docker run -d -p 27017:27017 --name mongo-d3-lab -e MONGODB_DATABASE=rsvpdata  -e COMPANY=deltatre mongo:3.3
```

Run the application specifing the host ip address as mongo host to let the containerized app accessing the mongo demon running on its own container
```
docker run --rm -ti -p 10002:5000 --name python-app -e MONGODB_HOST=$HOST_IP -e COMPANY=deltatre python-app:latest
```
**Beware of localhost** HOST_IP is the host ip: I cannot use localhost!

open the [web app](http://localhost:10002)

Stop the mongo container
```
docker stop mongo-d3-lab
```

show the stopped container
```
docker ps -a
```

show the [web app](http://localhost:10002) is no longer working due to missing db

restart the mongo container showing the app is working and data are still available
```
docker start mongo-d3-lab
```

## Container as toolbox

The ponzu docs example: use a container to create the documentation or IOW to browse locally the docs site.

## Container as development environment

Build the go webserver using the source code stored on the host using the go compiler running into the container
```
docker run --rm -d -v $PWD/go-app:/usr/src/myapp -w /usr/src/myapp golang:alpine go build -v -o go-webserver
```

go-webserver file will be created into the local go-app folder as build result

Build and run the source code stored on the host from the interactive shell provided by the running container
```
docker run --rm -it -p 8082:80 -v $PWD/go-app:/usr/src/myapp -w /usr/src/myapp golang:alpine sh
```

*windows* run the previous command from powershell or from gitbash do the following escaping
```
docker run --rm -it -p 8082:80 -v $PWD/go-app:/usr/src/myapp -w //usr/src/myapp golang:alpine sh
```

from the container shell build&run the go app
```
go run webserver.go
```
and [browse the app](http://localhost:8082) from the host

uncomment the TTG route in the go file and run it again

[Python development environment sample](https://github.com/crixo/python-docker-dev) with changes watcher

[Nodejs development environment sample](https://github.com/crixo/node-docker-dev-sample) with changes watcher

[Debugging dotnetcore in docker](https://www.aaron-powell.com/posts/2019-04-04-debugging-dotnet-in-docker-with-vscode/)