#!/bin/bash

# Define image name as per our choice
IMAGE_NAME="myreactapp-image"

echo "Building the Docker image..."
docker build -t $IMAGE_NAME .

echo "Logging into Docker Hub..."
docker login -u joshuarakesh

echo "Pushing the image to Docker Hub..."
docker push $IMAGE_NAME

echo "Build and push completed successfully."
