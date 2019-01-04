#!/bin/bash
ARTIFACT=`packer build -machine-readable jenkins-packer.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'`
AMI_ID=`echo $ARTIFACT | cut -d ':' -f2`
echo 'variable "AMI_ID" { default = "'${AMI_ID}'" }' > amivar.tf
terraform init
terraform apply -var "PATH_TO_PUBLIC_KEY=jenkins-key.pub" --auto-approve