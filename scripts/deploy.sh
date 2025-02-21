#!/bin/bash

# Define variables
AWS_REGION="us-east-2"
AWS_ACCOUNT_ID="692859914450"
IMAGE_NAME="insurance_app"
REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}

# Stop and remove existing container
docker stop insurance-container || true
docker rm insurance-container || true

# Pull new image from ECR
docker pull ${REPOSITORY_URI}:latest

# Run the application container
docker run -d -p 80:5000 --name insurance-container ${REPOSITORY_URI}:latest
