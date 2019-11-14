# Deploy a container image to an azure *webapp for container*

https://docs.microsoft.com/en-us/azure/app-service/containers/tutorial-custom-docker-image#create-a-web-app


## The Docker way

- Use a microsoft image containing the azure cli, so you do nota heve to install it locally, to create the service pricipal that will be needed to make fully automated the azure resources provisioning and the container deployment
```
docker run --rm -it microsoft/azure-cli:latest
```
Use the following commands to create the SP
```
AZURE_SUBSCRIPTION=$1
az login
az account set --subscription=$AZURE_SUBSCRIPTION
az ad sp create-for-rbac -n "ttg-demo-app" --role="Contributor" --scopes="/subscriptions/$AZURE_SUBSCRIPTION"
```
**az login** creates a link to be used with a browser to interactvely finalize the autentication.  
Once the operation will be completed through the browser interface, the pending cli task will be finalized.

- [Create a Service Principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal) through the azure portal.  
The SP will be used to login on the azure portal during the script execution avoiding any manual intervention.  
The service priciple can be reused for other task, so you do not have to create it all the time you have to provisioning an environment in azure.  


- Push the docker image containing you app to a remote registry that will be used to retrieve the image that your script has to pull from the azure web app.  
That's exaclty what we did during the first lab.  
For this demo we are going to use the public docker hub (the standard docker registry)
```
docker login -u crixo
docker tag dotnetcore-api:latest crixo/dotnetcore-api:latest
docker push crixo/dotnetcore-api:latest
```

- Create a [script using azure cli](./deploy-image-to-webapp/deploy-image-to-webapp.sh) provisioning the azure resources (web app for container) and deploying the docker image that contains your app.

- Create a docker image based on a microsoft image containing the azure cli, add the script you just created into the the image and set the script execution as the command that will be executed when you run the container.  
Review the [Dockerfile](./deploy-image-to-webapp/Dockerfile) that does all these steps.
```
cd deploy-image-to-webapp
docker build -t deploy-image-to-webapp .
```

- Run the docker image providing your azure settings as environment variables
```
docker run --rm -ti \
-e AZURE_SUBSCRIPTION=YOUR_AZURE_SUBSCRIPTION_ID \
-e RESOURCE_GROUP=docker-in-action \
-e IMAGE_NAME=YOUR_IMAGE_NAME \
-e CONTAINER_REGISTRY_UN=crixo \ 
-e CLIENT_ID=REFERS_TO_THE_SERVICE_PRINCIPAL_CREATED_ABOVE \
-e CLIENT_SECRET=REFERS_TO_THE_SERVICE_PRINCIPAL_CREATED_ABOVE \
-e TENANT_ID=THE_AZURE_TENANT_THAT_THE_SP_BELONGS_TO \
deploy-image-to-webapp
```
I'm using a local script w/ my azure values
```
sh docker-run-local.sh dotnetcore-api
sh docker-run-local.sh go-webserver
```

In case you need to use a private container registry, you have to provide also the url and the credentials to access the private registry (refers to the documentation provided w/ the link at the topo of this page. The bash script contains the required azure cli command that has been commented out for this demo)

For the sample we decided to use the public docker hub registry.  
You can get the url using the docker cli
```
docker info
```
but that's not expliclty need since docker hub is the default registry used by the *webapp* to pull the image defined through the azure cli. 

- browse the app and check the environemnt variable through swagger
https://docker-in-action-YOUR_IMAGE_NAME.azurewebsites.net/

Show the following on azure portal
- add *application settings* (aka environment variables) and retrieve it from swagger
- enable logs and show the stdout in the *container settings* section

-  Clean up 
```
AZURE_SUBSCRIPTION=300aa066-33d1-4cd8-9cac-ef9082a33e4b
RESOURCE_GROUP=docker-in-action
az login
az group delete --subscription $AZURE_SUBSCRIPTION --name $RESOURCE_GROUP --yes
```