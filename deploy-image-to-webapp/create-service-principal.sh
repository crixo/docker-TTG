AZURE_SUBSCRIPTION=$1
az login
az account set --subscription=$AZURE_SUBSCRIPTION
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/$AZURE_SUBSCRIPTION"