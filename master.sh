
#!/usr/bin/env bash

source master.conf

DIRECTORY=`pwd`
#Launch every services from master.conf in the same order
for i in "${POD_SERVICES[@]}"
do
  CURRENT_SERVICE="$POD_PROVIDER/$i/"
  echo "service : "$CURRENT_SERVICE
  if [ -d $CURRENT_SERVICE ]; then
  	cd $CURRENT_SERVICE
    echo "####################################################"
    echo "ip used : "${!POD_GLCOUD_DOCKER_JENKINS_IP_VARIABLE}
    . ./create.sh

  	cd $DIRECTORY
  else
    echo "service \"$i\" not found"
  fi
done
