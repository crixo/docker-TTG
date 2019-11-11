# CONTAINER_REGISTRY=$1
# CONTAINER_REGISTRY_UN=$2
# CONTAINER_REGISTRY_PWD=$3
# AZURE_SUBSCRIPTION=$4
# IMAGE_NAME=$5
# RESOURCE_GROUP=$6
SERVICE_PLAN="$RESOURCE_GROUP-service-plan"
WEBAPP_NAME="$RESOURCE_GROUP-$IMAGE_NAME"
SOURCE_IMAGE_NAME="$IMAGE_NAME:latest"

if [ "$CONTAINER_REGISTRY" = '__DEFAULT_CONTAINER_REGISTRY__' ]
then
   AZURE_IMAGE_NAME="$CONTAINER_REGISTRY_UN/$IMAGE_NAME:latest"
else
   AZURE_IMAGE_NAME="$CONTAINER_REGISTRY/$IMAGE_NAME:latest"
fi

echo "AZURE_IMAGE_NAME: $AZURE_IMAGE_NAME"

# echo 'Pushing to conatiner registry '$CONTAINER_REGISTRY
# docker login -u $CONTAINER_REGISTRY_UN -p $CONTAINER_REGISTRY_PWD "https://$CONTAINER_REGISTRY"
# docker tag $SOURCE_IMAGE_NAME $AZURE_IMAGE_NAME
# docker push $AZURE_IMAGE_NAME
echo "azure image to push to the webapp: $AZURE_IMAGE_NAME"
echo "service plan: $SERVICE_PLAN"
echo "WEBAPP_NAME: $WEBAPP_NAME"
echo "login w/ service principal for CLIENT_ID:$CLIENT_ID CLIENT_SECRET:$CLIENT_SECRET TENANT_ID:$TENANT_ID"
az login --service-principal -u $CLIENT_ID -p $CLIENT_SECRET --tenant $TENANT_ID
#sleep 5
# you should be already logged in
az account set --subscription $AZURE_SUBSCRIPTION
echo "Creating resource group $RESOURCE_GROUP ..."
az group create --subscription $AZURE_SUBSCRIPTION --name $RESOURCE_GROUP --location "West Europe"
#sleep 5
echo "Creating appservice $SERVICE_PLAN ..."
az appservice plan create --name $SERVICE_PLAN --resource-group $RESOURCE_GROUP --sku B1 --is-linux
#sleep 5
echo "Creating webapp $WEBAPP_NAME..."
az webapp create --resource-group $RESOURCE_GROUP \
--plan $SERVICE_PLAN \
--name $WEBAPP_NAME \
--deployment-container-image-name $AZURE_IMAGE_NAME
sleep 5

if [ "$CONTAINER_REGISTRY" != '__DEFAULT_CONTAINER_REGISTRY__' ]
then
 echo 'Associating webapp to container image stored into a custom registry...'
 az webapp config container set --name $WEBAPP_NAME \
 --resource-group $RESOURCE_GROUP \
 --docker-custom-image-name $AZURE_IMAGE_NAME \
 --docker-registry-server-url "https://$CONTAINER_REGISTRY" \
 --docker-registry-server-user $CONTAINER_REGISTRY_UN \
 --docker-registry-server-password $CONTAINER_REGISTRY_PWD
 sleep 5
fi
echo 'Setting appsettings for the webapp just created...'
az webapp config appsettings set -g $RESOURCE_GROUP -n $WEBAPP_NAME --settings docker=is-awesome
#sleep 5
echo 'DONE'