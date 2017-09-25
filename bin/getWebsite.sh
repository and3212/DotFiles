#!/bin/bash
# Author: Liam Lawrence
# Date: September 24, 2017
# Downloads an entire website offline

echo "Enter the name of the website you would like to download"
read webName

read -sp "Do you want to overwrite previously downloaded files from this website? [y/N]" -n 1 -r
REPLY=${REPLY,,}

if [ "$REPLY" != "y" ]; then
    wget --recursive --page-requisites --convert-links --restrict-file-names=windows --no-clobber $webName
else
    wget --recursive --page-requisites --convert-links --restrict-file-names=windows $webName
fi

exit
