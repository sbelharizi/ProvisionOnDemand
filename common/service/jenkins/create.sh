#!/usr/bin/env bash

mkdir temp

#TF_VAR_POD_GCP_EXTERNAL_IP="35.224.190.137"
#POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE="TF_VAR_POD_GCP_EXTERNAL_IP"
#POD_GLCOUD_DOCKER_JENKINS_USER="ubuntu"
#TF_VAR_POD_GCP_PRIV_KEY="~/Downloads/ssh/TestAwsFirstInstance.pem"



echo "var : " $POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE
echo "ip used : "${!POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE}

for i in $(ls job/jenkinsfile)
do
  cat job/template-up.xml > temp/template-$i.xml
  cat job/jenkinsfile/$i/$i.jenkinsfile >> temp/template-$i.xml
  cat job/template-down.xml >> temp/template-$i.xml
done

#if ! [[ $POD_GLCOUD_DOCKER_JENKINS_LOCAL ]]; then
  tar -cvf jenkins-package.tar.gz docker-compose.yml jenkins-plugin-list Dockerfile
  echo "sending file ...."

  scp -oStrictHostKeyChecking=no -i $TF_VAR_POD_GCP_PRIV_KEY \
    -p jenkins-package.tar.gz     \
    $POD_GLCOUD_DOCKER_JENKINS_USER@${!POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE}:~

  echo "file sent"

  ssh -oStrictHostKeyChecking=no -o "UserKnownHostsFile /dev/null" -i $TF_VAR_POD_GCP_PRIV_KEY  \
    $POD_GLCOUD_DOCKER_JENKINS_USER@${!POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE} bash -c "'
    tar -xvf jenkins-package.tar.gz
    docker-compose up --build -d
    exit
    '"

until $(curl --output /dev/null --silent --head --fail http://${!POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE}:8080); do
    printf '.'
    sleep 5
done

echo "install jobs"

./job/create-job.sh ${!POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE} 8080

rm -rf job/temp
rm jenkins-package.tar.gz
