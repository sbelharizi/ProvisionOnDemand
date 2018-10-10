#!/usr/bin/env bash

source master.conf

PWD=`pwd`
#Launch every services from master.conf in the same order
for i in "${POD_SERVICES[@]}"
do
  CURRENT_SERVICE="$POD_PROVIDER/$POD_TYPE/$i/"
  if [ -d $CURRENT_SERVICE ]; then
  	cd $CURRENT_SERVICE
  	echo $CURRENT_SERVICE
  	./delete.sh
  	cd $PWD
    #./"$CURRENT_SERVICE/create.sh"
  else
    echo "service \"$i\" not found"
  fi
done
