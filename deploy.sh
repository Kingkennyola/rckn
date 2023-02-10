#!/bin/bash

image_tag=$1
echo "Deploying nginx image with image tag $1"

helm install rackner bitnami/nginx --set image.version="$image_tag"

kubectl get svc --namespace default -w rackner-nginx