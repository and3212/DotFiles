#!/bin/bash
# Author: Liam Lawrence
# Date: December 23, 2017
# Rips out information from PDFs to make pinouts easier for PCB design

FPAGE=$1
LPAGE=$2
FILEPATH=$3
NAME=$(basename $FILEPATH)
NAME=${NAME%.*}

# Gets the file data and stores it in pdfName.txt
pdftotext -f $FPAGE -l $LPAGE -layout -nopgbrk -eol "unix" $FILEPATH $NAME.txt

# Removes the last word
WORD=$(cat "$NAME.txt" |  
    sed -e 's/  */ /g' |
    sed -e 's# O PIO, I, PU, ST##' | 
    sed -e 's# I PIO, I, PU, ST##' | 
    sed -e 's# PIO, I, PU, ST##')

# Replaces the last word with the I/O data
WORD=$(echo "$WORD" | sed 's/.*/& x/' | awk '{$NF=$4}1' | cut -d ' ' -f4 --complement)

# Deletes the old text file and creates a .CSV
rm $NAME.txt
touch $NAME.csv

# Places / between the description words
echo "$WORD" | while read line ; do
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
