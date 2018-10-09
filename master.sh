
#!/usr/bin/env bash

source master.conf

#Launch every services from master.conf in the same order
for i in "${POD_SERVICES[@]}"
do
  CURRENT_SERVICE="$POD_PROVIDER/$POD_TYPE/$i/"
  if [ -d $CURRENT_SERVICE ]; then
    ./"$CURRENT_SERVICE/create.sh"
  else
    echo "service \"$i\" not found"
  fi
done

