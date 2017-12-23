#!/bin/bash
# Author: Liam Lawrence
# Date: December 23, 2017
# Creates a .CSV file from an Atmel pinout PDF

FPAGE=$1
LPAGE=$2
FILEPATH=$3
NAME=$(basename $FILEPATH)
NAME=${NAME%.*}
CONFIGFILE=$4

# Gets the file data and stores it in pdfName.txt
pdftotext -f $FPAGE -l $LPAGE -layout -nopgbrk -eol "unix" $FILEPATH $NAME.txt

# Removes extra spaces and applies the config file
WORD=$(cat "$NAME.txt" | sed -e 's/  */ /g')
while read line; do
    WORD=$(echo "$WORD" | sed -e "$line")
done < <(cat "$CONFIGFILE")


# Replaces the last word with the I/O data
WORD=$(echo "$WORD" | sed 's/.*/& x/' | awk '{$NF=$4}1' | cut -d ' ' -f4 --complement)


# Deletes the old text file and creates a .CSV
rm $NAME.txt
> $NAME.csv


# Places / between the description words
# and writes out to a .CSV file
echo "$WORD" | while read line; do

    # Finds the number of words in each line - 2
    COUNTER=$(echo "$line" | wc -w)
    let COUNTER=COUNTER-2

    # Main loop that goes through and places the /
    for i in $(seq $COUNTER -1 3); do
        line=$(echo "$line" | sed -e "s/ /\//$i") 
    done

    # Adds it to the file
    echo ${line// /,} >> $NAME.csv

done
