#!/bin/bash

#script create des terraform !

echo "let's start out $POD_PROVIDER plateform creation !"


terraform init 
terraform plan -out plan.terraform 


#echo "APPLICATION DU PLAN TERRAFORM"
terraform apply "plan.terraform" 


#on sources les ip externes de outputs.sh pour les recuperer et eventuellement push des packages dans les VMs associees
echo "on se trouve dans $PWD"
. terraform_outputs.sh 


echo "liste des adresses ip : $TF_VAR_POD_COMMON_EXTERNAL_IP"