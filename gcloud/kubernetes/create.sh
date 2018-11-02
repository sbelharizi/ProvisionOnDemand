#!/bin/bash

echo "let's start !"

#echo $POD_PROJECT_LOCATION/common/utils/terraform_script/create.sh

. $POD_PROJECT_LOCATION/common/utils/terraform_script/create.sh


#terraform init
#terraform plan -out plan.terraform


#echo "APPLICATION DU PLAN TERRAFORM"
#terraform apply "plan.terraform"


#on sources les ip externes de outputs.sh pour les recuperer et eventuellement push des packages dans les VMs associees
#source terraform_outputs.sh


#echo "liste des adresses ip : $TF_VAR_POD_AWS_PUBLIC_IP"


echo "on genere les identifians pour l'installation de helm/tiller  nom du projet GCP : $TF_VAR_POD_GCP_PROJECT "
gcloud container clusters get-credentials  $TF_VAR_POD_GCP_PROJECT  --project $TF_VAR_POD_GCP_PROJECT --zone=$TF_VAR_POD_GCP_ZONE


echo "on applique tiller sur le cluster"
kubectl apply -f jenkins/tiller-rbac.yaml



echo "initialisation du compte de service tiller"
helm init --service-account tiller


sleep 60

echo "installation de jenkins"
helm install --name my-jenkins stable/jenkins


