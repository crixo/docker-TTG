# Managing files and data

## Share files between host and container

### Copy file explicitly
- Run a container into a separate shell
```
CNT_NAME_OR_ID=copy-sample
docker run --rm --name copy-sample -ti alpine:3.8
```

Open a second terminal

- Prepare the file and scripts
```
echo "foo file content" > foo.txt
CNT_NAME_OR_ID=copy-sample
```

- Copy a file from host to container:
```
docker cp foo.txt $CNT_NAME_OR_ID:/foo.txt
```

- Remove the file on host
```
rm foo.txt
```

- Copy a file from Docker container to host:
```
docker cp $CNT_NAME_OR_ID:/foo.txt foo.txt
```

- Show the file added into the container filesystem.  
Switch to the first terminal and run the following command from the container shell
```
ls
```

- Clean Up
```
rm foo.txt
exit

# now you are into the host shell
rm foo.txt
```
Exiting the container, the container will be stopped and remove due to the --rm flag and also due to the shell is the main process.  
Exiting the shell container has nothing else to do

### Use volumes
```windows git shell only
pattern=/c/
replace="c:/"
PWD=${PWD/$pattern/$replace}
echo $PWD
```

- Run the container setting up a volume to share files between container and host
```
docker run --rm --name copy-sample -v $PWD:/my-volume -ti alpine:3.8
```

- Navigate to the /my-volume folder through the interactive shell provided by the running container
```
cd /my-volume
ls
```
Now you are browsing the host files as part of the container filesystem.  

- Create a file on the container filesystem using the container interactive shell
```
touch foo.txt
```
You should see the file on host filesystem as well

- Clean Up
```
rm foo.txt
exit
```

## Stateful app
- Run MongoDb in a container
```
docker run --rm -d -p 27017:27017 --name mongo-d3-lab -e MONGODB_DATABASE=rsvpdata  -e COMPANY=deltatre mongo:3.3
```
You can connect to mongo instance running within the container using any mongo client.  

- The database data lives within the container itself
```
docker exec -ti mongo-d3-lab /bin/sh
```

- From the container shell
```
cd /data/db 
ls
```

- Stop&Remove the mongo container (see --rm flag used to run it)
```
docker stop mongo-d3-lab
```

- Run the container configuring a volume to store the database data on the host instead into the container
```
docker run --rm -d -p 27017:27017 --name mongo-d3-lab -e MONGODB_DATABASE=rsvpdata -v $PWD/mongodata:/data/db  -e COMPANY=deltatre mongo:3.3
```

[why is not working on Windows](https://hub.docker.com/_/mongo) while now works on [OS X](https://stackoverflow.com/questions/29570989/docker-mongodb-share-volume-with-mac-os-x)

- Build the image of the [python app](https://github.com/cloudyuga/rsvpapp) using the mongo container
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
HOST_IP=$(ipconfig | grep -A 5 "Ethernet adapter Ethernet" | grep -E -o -m 1 "([0-9]{1,3}[\.]){3}[0-9]{1,3}")

ip addr show

ipconfig getifaddr en0

HOST_IP=$(ipconfig getifaddr en0)
```

- Run the mongo container w/o the --rm flag and w/o volume
```
docker run -d -p 27017:27017 --name mongo-d3-lab -e MONGODB_DATABASE=rsvpdata  -e COMPANY=deltatre mongo:3.3
```

- Run the application specifying the host ip address as mongo host to let the containerized app accessing the mongo demon running on its own container
```
docker run --rm -ti -p 10002:5000 --name python-app -e MONGODB_HOST=$HOST_IP -e COMPANY=deltatre python-app:latest
```
**Beware of localhost** HOST_IP is the host ip: I cannot use localhost!

- open the [web app](http://localhost:10002)

- Open a new shell so the webapp is still running outputting in the first shell

- Stop the mongo container
```
docker stop mongo-d3-lab
```

- Show the stopped container
```
docker ps -a
```

- show the [web app](http://localhost:10002) is no longer working due to missing db

- Restart the mongo container showing the app is working and data are still available... 
```
docker start mongo-d3-lab
```
**!!! DO NOT TRY AT HOME !!!!** As soon as the container will be removed/destroyed and it will... **data are gone**!

- Clean Up
```
docker rm -f mongo-d3-lab
```

## Container as toolbox

The ponzu docs example: use a container to create the documentation or IOW to browse locally the docs site.

## Container as development environment

- Build the go webserver using the source code stored on the host using the go compiler running into the container
```
docker run --rm -d -v $PWD/go-app:/usr/src/myapp -w /usr/src/myapp golang:alpine go build -v -o go-webserver
```
go-webserver file will be created into the local go-app folder as build result

- Clean up
```
rm $PWD/go-app/go-webserver
```

- Build and run the source code stored on the host from the interactive shell provided by the running container
```
docker run --rm -it -p 8082:80 -v $PWD/go-app:/usr/src/myapp -w /usr/src/myapp golang:alpine sh
```

- From the container shell build&run the go app
```
go run webserver.go
```
and [browse the app](http://localhost:8082) from the host

- Uncomment the TTG route in the go file and run it again

[Python development environment sample](https://github.com/crixo/python-docker-dev) with changes watcher

[NodeJs development environment sample](https://github.com/crixo/node-docker-dev-sample) with changes watcher

[Debugging dotnetcore in docker](https://www.aaron-powell.com/posts/2019-04-04-debugging-dotnet-in-docker-with-vscode/)