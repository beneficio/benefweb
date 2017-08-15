#!/bin/bash
fileIN=$1
extOUT=".tmp"
fileOUT=$fileIN$extOUT
chmod 666 $fileIN
iconv -f ISO-8859-1 -t UTF-8 $fileIN > $fileOUT
cp $fileOUT $fileIN 
rm $fileOUT
echo "convertFile  $fileIN --> ok"
