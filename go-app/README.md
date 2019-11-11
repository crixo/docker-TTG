docker run --rm -v c:/Users/cristiano.degiorgis/Source/RepoSamples/k8s-d3-training/go-app:/usr/src/myapp -w /usr/src/myapp golang:alpine go build -v

docker run --rm -it -p 8082:80 -v c:/Users/cristiano.degiorgis/Source/RepoSamples/k8s-d3-training/go-app:/usr/src/myapp -w /usr/src/myapp golang:alpine sh

- build image using Dockerfile
```
docker build -t go-webserver .
```

- tag the image to push it to the docker hub
```
docker tag go-webserver crixo/go-webserver
```

- push the image to the docker hub
It requires you first login to the docker hub
```
docker login
```
that allows to provide the required credentials interactively

```
docker push crixo/go-webserver
```
