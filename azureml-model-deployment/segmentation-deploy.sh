set -x
# The commands in this file map to steps in this notebook: https://aka.ms/azureml-infer-sdk-image-instance-segmentation
# The sample scoring file available in the same folder as the above notebook

# script inputs
registry_name="azureml"
subscription_id=$1
resource_group_name=$2
workspace_name=$3

# This is the model from system registry that needs to be deployed
model_name="AutoML-Image-Instance-Segmentation"
model_label="latest"

version=$(date +%s)
endpoint_name="image-is-$version"

# Todo: fetch deployment_sku from the min_inference_sku tag of the model
deployment_sku="Standard_NC6s_v3"


# 1. Setup pre-requisites
if [ "$subscription_id" = "<SUBSCRIPTION_ID>" ] || \
   ["$resource_group_name" = "<RESOURCE_GROUP>" ] || \
   [ "$workspace_name" = "<WORKSPACE_NAME>" ]; then 
    echo "Please update the script with the subscription_id, resource_group_name and workspace_name"
    exit 1
fi

az account set -s $subscription_id
workspace_info="--resource-group $resource_group_name --workspace-name $workspace_name"

# 2. Check if the model exists in the registry
# Need to confirm model show command works for registries outside the tenant (aka system registry)
if ! az ml model show --name $model_name --label $model_label --registry-name $registry_name 
then
    echo "Model $model_name:$model_version does not exist in registry $registry_name"
    exit 1
fi

model_version=$(az ml model show --name $model_name --label $model_label --registry-name $registry_name --query version --output tsv)

# 3. Deploy the model to an endpoint
# Create online endpoint 
az ml online-endpoint create --name $endpoint_name $workspace_info  || {
    echo "endpoint create failed"; exit 1;
}

# Deploy model from registry to endpoint in workspace
az ml online-deployment create --file deploy-online.yaml $workspace_info --set \
  endpoint_name=$endpoint_name model=azureml://registries/$registry_name/models/$model_name/versions/$model_version \
  instance_type=$deployment_sku || {
    echo "deployment create failed"; exit 1;
}

# get deployment name and set all traffic to the new deployment
yaml_file="deploy-online.yaml"
get_yaml_value() {
    grep "$1:" "$yaml_file" | awk '{print $2}' | sed 's/[",]//g'
}
deployment_name=$(get_yaml_value "name")

az ml online-endpoint update $workspace_info --name=$endpoint_name --traffic="$deployment_name=100" || {
    echo "Failed to set all traffic to the new deployment"
    exit 1
}


