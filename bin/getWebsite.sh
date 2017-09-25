#!/bin/bash
# Author: Liam Lawrence
# Date: September 24, 2017
# Downloads an entire website offline

echo "Enter the name of the website you would like to download"
read webName

wget --recursive --no-clobber --page-requisites --convert-links --restrict-file-names=windows --no-clobber $webName
