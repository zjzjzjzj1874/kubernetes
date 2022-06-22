#!/bin/bash -e

containerName="access-rpc"
echo "begin to deploy ${contanierName}"

image="access-rpc:latest"
#image="redis.yaml"
templateDir="/home/ubuntu/k3s/deployment/template"
accessRPCDeployment="deployment-access-rpc"

sudo cp ${templateDir}/deployment.yaml ./deployment-${containerName}.yaml

sudo sed -i "s,{{deployment-name}},${accessRPCDeployment},g" deployment-${containerName}.yaml
sudo sed -i "s,{{container-name}},${containerName},g" deployment-${containerName}.yaml
sudo sed -i "s,{{image}},${image},g" deployment-${containerName}.yaml

sudo cat deployment-${containerName}.yaml

echo "ready to deploy ${contanierName}"

sudo kubectl apply -f deployment-${containerName}.yaml

sudo kubectl get pod

echo "finsh"
