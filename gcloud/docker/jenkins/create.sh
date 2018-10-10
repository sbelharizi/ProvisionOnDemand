#!/usr/bin/env bash

mkdir temp

for i in $(ls job/jenkinsfile)
do
  cp job/template.xml temp/template-$i.xml
  JENKINSFILE=`cat job/jenkinsfile/$i/$i.jenkinsfile | tr -d '\n'`
  sed -i '' "s/{{ jenkinsfile }}/$JENKINSFILE/g" temp/template-$i.xml
done

docker-compose up --build -d
./job/create-job.sh

rm -rf job/temp
