#!/bin/bash

echo "let's start !"



#Initialisation de la VM par defaut machine type f1-micro
#gcloud compute --project=$POD_GCLOUD_PROJECT instances create $POD_GCLOUD_INSTANCE_NAME --zone=$POD_GCLOUD_ZONE --machine-type=$POD_GCLOUG_VM_TYPE  --metadata-from-file=startup-script=/Users/sofiane.belharizi/Documents/ProvisionOnDemand/gcloud/VM/jenkins/StartupScriptInstallJenkins.sh


echo "var du projet TF $TF_VAR_POD_GCP_PROJECT"

terraform init
terraform plan -out plan.terraform


echo "APPLICATION DU PLAN TERRAFORM"
terraform apply "plan.terraform"


#on sources les ip externes de outputs.sh pour les recuperer et eventuellement push des packages dans les VMs associees

source terraform_outputs.sh


echo "liste des adresses ip : $TF_VAR_POD_GCP_EXTERNAL_IP"