#!/bin/bash

# Define image name
IMAGE_NAME="myreactapp-image"

echo "Pulling the latest Docker image..."
docker pull $IMAGE_NAME

echo "Stopping and removing existing container (if any)..."
docker-compose down

echo "Deploying the new container..."
docker-compose up -d --force-recreate

echo "Deployment completed successfully."
