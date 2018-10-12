#!/usr/bin/env bash

#$1 : ip
#$2 : port

JENKINSFILE_LOCATION="temp"

for i in $(ls $JENKINSFILE_LOCATION)
do
  echo $i
  java -jar jenkins-cli.jar -s http://$1:$2/ create-job $i < $JENKINSFILE_LOCATION/$i
done
