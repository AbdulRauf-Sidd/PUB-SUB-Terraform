#!/bin/bash

echo "Deploying infrastructure..."
cd terra
terraform init
terraform apply -var-file="terraform.tfvars" -auto-approve

echo "Exporting outputs..."
terraform output -json > tf_output.json

echo "Running Flask app..."
cd ..
flask run
