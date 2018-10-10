#!/bin/bash

echo "let's start !"



echo "$POD_GCLOUD_PROJECT"




#Initialisation de la VM par defaut machine type f1-micro
#gcloud compute --project=$POD_GCLOUD_PROJECT instances create $POD_GCLOUD_INSTANCE_NAME --zone=$POD_GCLOUD_ZONE --machine-type=$POD_GCLOUG_VM_TYPE  --metadata-from-file=startup-script=/Users/sofiane.belharizi/Documents/ProvisionOnDemand/gcloud/VM/jenkins/StartupScriptInstallJenkins.sh


echo "var du projet TF $TF_VAR_POD_GCP_PROJECT"



#init terraform : terraform init
#test configuration : terraform plan -out plan.terraform
#run terraform : terraform apply