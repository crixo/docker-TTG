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
- do not rely on that convention to get the latest build
- do not rely on the tag for immutability. New image can be created w/ the same tag but w/ different content: check the ***image ID***
- use always a [full semantic version tag](https://medium.com/@mccode/using-semantic-versioning-for-docker-image-tags-dfde8be06699) (eg.3.1.300) where available, not a partial alias (eg. 3.1)

## Run container
```
docker run --rm -d --name dotnetcore-api -e my-env-var=my-env-var-value -p 10001:80 dotnetcore-api:latest
```
Use [swagger ui](http://localhost:10001) to test the environment variable through the configuration api. Pay attention to the followings results:
-  ASPNETCORE_ENVIRONMENT is null
-  my-env-var is equals to my-env-var-value

show running container
```
docker ps | grep dotnetcore-api
```

## Interact with a running container
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
through its [swagger ui](http://localhost:10011)

## Stop a running container
```
docker stop dotnetcore-api

docker ps -a | grep dotnetcore-api
```
container is not just stoped, but it's gone due to --rm flag

## Data within a container are ephemeral
The data I wrote into the appsettings.json that belongs to the container image are not longer there.
```
docker run --rm -ti -e my-env-var=my-env-var-value --entrypoint "/bin/sh" dotnetcore-api:latest -c "cat appsettings.json" 
```

## Play with the container registry
spawn your own local registry... 
```
docker run --rm -d -p 10000:5000 --name registry registry:2
```
same as [docker hub](https://hub.docker.com/) but [locally](http://localhost:10000/v2/)... pretty cool isn't it?

tag image for the registry
```
docker tag dotnetcore-api:latest localhost:10000/dotnetcore-api:latest
```

## push the tagged image to the registry
then push the local image into the local registry
```
docker push localhost:10000/dotnetcore-api:latest
```

Browse the [registry catalog](http://localhost:10000/v2/_catalog). Here the [official documentation](https://docs.docker.com/registry/spec/api/)

browse the [image manifest](http://localhost:10000/v2/dotnetcore-api/manifests/latest) you just push through the registry api providing image name and sha or tag
```
IMAGE_NAME=dotnetcore-api
TAG=latest
URL="http://localhost:10000/v2/$IMAGE_NAME/manifests/$TAG"
curl $URL
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