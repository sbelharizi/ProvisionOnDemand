#!/bin/bash

echo "let's start !"



#Initialisation de la VM par defaut machine type f1-micro
#gcloud compute --project=$POD_GCLOUD_PROJECT instances create $POD_GCLOUD_INSTANCE_NAME --zone=$POD_GCLOUD_ZONE --machine-type=$POD_GCLOUG_VM_TYPE  --metadata-from-file=startup-script=/Users/sofiane.belharizi/Documents/ProvisionOnDemand/gcloud/VM/jenkins/StartupScriptInstallJenkins.sh

echo "APPLICATION DU PLAN TERRAFORM"

. $POD_PROJECT_LOCATION/common/utils/terraform_script/delete.sh

#terraform destroy