#!/usr/bin/env bash

JENKINSFILE_LOCATION="temp"

for i in $(ls $JENKINSFILE_LOCATION)
do
  echo $i
  java -jar jenkins-cli.jar -s http://localhost:8080/ create-job $i < $JENKINSFILE_LOCATION/$i
done
