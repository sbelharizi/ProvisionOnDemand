#!/bin/bash

echo "let's start out AWS plateform creation !"



terraform init
terraform plan -out plan.terraform


echo "APPLICATION DU PLAN TERRAFORM"
terraform apply "plan.terraform"


#on sources les ip externes de outputs.sh pour les recuperer et eventuellement push des packages dans les VMs associees
source terraform_outputs.sh


echo "liste des adresses ip : $TF_VAR_POD_AWS_PUBLIC_IP"