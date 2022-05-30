#!/bin/bash

echo ''
echo 'Extracting File'
echo ''

#Check if the script was run with empty argument
if [ "$1" = "" ]
  then

        echo "Please pass in a file name when running this script"
        echo "For example, 'extract VMware-vCenter-support-2022-05-27@23-41-27.zip'"
        exit 0
fi


lastThree=${1: -3}
lastFive=${1: -7}

if [ $lastThree = "zip" ]
   then
      chmod 777 $1
      unzip $1
      echo "Finished unpacking .zip file!"
      exit 0
fi

if [ $lastThree = "tgz" ]
   then
      chmod 777 $1
      tar -xzvf $1
      echo "Finished unpacking the .tgz file!"
      exit 0
fi

if [ $lastFive = ".tar.gz" ]
   then
      chmod 777 $1
      tar -xvf $1
      echo "Finished unpacking the .tar.gz file!"
      exit 0
fi



