#!/usr/bin/env bash

mkdir temp

for i in $(ls job/jenkinsfile)
do
  cat job/template-up.xml > temp/template-$i.xml
  cat job/jenkinsfile/$i/$i.jenkinsfile >> temp/template-$i.xml
  cat job/template-down.xml >> temp/template-$i.xml
done

#docker-compose up --build -d
#sleep 30
#./job/create-job.sh

#rm -rf job/temp
