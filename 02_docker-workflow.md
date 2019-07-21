# DotNetCore API

## Create Dockerfile
use the [Dockerfile](dotnetcore-api/Dockerfile) to understand the multi-stage build approach

## Build docker image
```
cd dotnetcore-api
docker build -t dotnetcore-api:latest .
```
remove multi-stage images
```
docker images -q --filter dangling=true | xargs docker rmi
```

***latest*** is just a convention
-  do not rely on that convention to get the latest buils
-  do not rely on the tag for immutability.  New image can be created w/ the same tag but w/ different content: check the ***image ID***

## Run container
```
docker run --rm -d --name dotnetcore-api -e my-env-var=my-env-var-value -p 10001:80 dotnetcore-api:latest
```
Use swagger ui to test the environment variable through the configuration api. Pay attention to the followings results:
-  ASPNETCORE_ENVIRONMENT is null
-  my-env-var is equlas to my-env-var-value

show running container
```
docker ps | grep dotnetcore-api
```

## Interact with a running container
*windows* run it in powershell
```
docker exec -ti dotnetcore-api /bin/sh
```
Modify the appsettings.json 
```
rm appsettings.json && echo '{"Logging":{"LogLevel":{"Default":"Warning"}},"AllowedHosts":"*","enriched":"yes"}' > appsettings.json
cat appsettings.json
```

## Create an image from a running container
```
docker commit <running container ID>  dotnetcore-api-enriched:latest

docker images | grep dotnetcore-api
```
run the new image and show the difference between original image vs new image running the related containers
```
docker run --rm -d -p 10011:80 dotnetcore-api-enriched:latest
```

## Stop a running container
```
docker stop dotnetcore-api

docker ps -a
```
contianer is not just stoped, but it's gone due to --rm flag


## Play with the container registry
tag image for the registry
```
docker tag dotnetcore-api:latest localhost:10000/dotnetcore-api:latest
```

## push the tagged image to the registry
run first the registry container]
```
docker run --rm -d -p 10000:5000 --name registry registry:2
```

then push the local image into the local registry
```
docker push localhost:10000/dotnetcore-api:latest
```

push the image to docker hub
```
docker login -u crixo
docker tag dotnetcore-api:latest crixo/dotnetcore-api:latest
docker push crixo/dotnetcore-api:latest
```

list all local images related to our dotnetcore-api
```
docker images | grep dotnetcore-api
```

remove a single image
```
docker rmi <image name>
```

pull image from local registry. Keep in mind the the following: *local registry != local docker engine*

```
docker pull localhost:10000/dotnetcore-api:latest
```
 
run the image downloaded from the local registry
```
docker run --rm -d --name dotnetcore-api -e my-env-var=my-env-var-value -p 10001:80 localhost:10000/dotnetcore-api:latest
```