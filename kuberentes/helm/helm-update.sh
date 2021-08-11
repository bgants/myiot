#!/bin/bash

dirs=(*/)
for dir in "${dirs[@]}"
do
  if [[ "$dir" != "common/" && "$dir" != "myiot/" ]]
  then
    echo "Updateing helm deps in "$dir" ..."
    rm -rf "$dir/charts"
    helm dep up "$dir"
    echo
  fi
done    
echo "Updating myiot dependecies in myiot/ ..."
rm -rf myiot/charts
helm dep up myiot
echo
